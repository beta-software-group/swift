from behave import *  # Behave example: https://github.com/behave/behave.example/tree/master/features
from selenium.webdriver.common.by import By
import time


@given('we are creating a new task in "{task_list}"')
def step_impl(context, task_list):
    """
    Common steps that can be reused using example tables for future features

    Scenario Outline: Creation of tasks
        Given we are creating a new task in "<list>"
        When task is set to "<desc>" due at "<due>"
            And the task is saved
        Then the task description is in list "<list>"

        Examples:
            |        desc           |   due    |    list    |
            | Task creation [TEST]  |          | tomorrow   |
            | Task creation [TEST]  |          | today      |

    Scenario Outline: Toggle display of task due time if set
        Given we are creating a new task in "<list>"
        When task is set to "<desc>" due at "<due>"
            And the task is saved
        Then the task description is in list "<list>"
            And the task due time displayed is "<due>"

        Examples:
            |        desc           |   due    |    list    |
            | No due time [TEST]    |          | today      |
            | Due time [TEST]       | 0100 PM  | tomorrow   |


    Scenario Outline: Recurring tasks are shown in both lists
        Given we are creating a new task in "<target_list>"
        When task is set to "<desc>" due at "<due>"
            And the task is saved
        Then the task "<desc>" is on the page
            And task is in lists:
            | list     |
            | today    |
            | tomorrow |
            And the task due time displayed is "<due>"

        Examples:
            |        desc           |   due    |    target_list       |
            | RECUR: Recur [TEST]   |          | tomorrow             |
            | RECUR: Recur [TEST]   | 0100 PM  | today                |
    """
    context.task_list = task_list
    context.button_save = context.browser.find_element(By.ID, f'save_edit-{context.task_list}')
    context.input_description = context.browser.find_element(By.ID, f'input-{context.task_list}')
    time.sleep(0.25)


@when('task is set to "{description}" due at {due_time}')
def step_impl(context, description, due_time):
    context.input_description.clear()
    context.input_description.send_keys(description)
    context.description_new = description
    # Only input time if specified in examples for scenario outline; Allows for empty example fields
    if eval(due_time):
        # If the target_task WebElement exists, use it; Else target new task input fields in task_list
        if 'target_task' in context:
            context.target_task.find_element(By.CLASS_NAME, 'time_edit').click()
            context.target_task.find_element(By.CLASS_NAME, 'time_input').send_keys(due_time)
        else:
            context.browser.find_element(By.XPATH, f'//*[@id="time_edit-{context.task_list}"]').click()
            context.browser.find_element(By.ID, f'input-time-{context.task_list}').send_keys(due_time)


@when('the task is saved')
def step_impl(context):
    context.browser.find_element(By.ID, f'save_edit-{context.task_list}').click()
    # Wait for page refresh; Initialize WebElement that is (or should be) the task we just saved
    time.sleep(0.25)
    context.target_list = context.browser.find_element(By.XPATH, f'//*[@id="task-list-{context.task_list}"]')
    context.target_task = context.browser.find_elements(By.XPATH, f'//*[@id="task-list-{context.task_list}"]/tr')[-1]
    # Store the id attribute attached to the <tr> HTML element that holds target_task
    context.task_id = context.target_task.get_dom_attribute('id')
    # Only update description when task is saved
    context.description = context.description_new


@then('the task "{description}" is on the page')
def step_impl(context, description):
    # Strip "RECUR:" from description if it is present; Remove any leading whitespace
    context.description = description.removeprefix("RECUR: ").lstrip()
    assert(context.description in context.browser.page_source)


@then('the task description is in list "{task_list}"')
def step_impl(context, task_list):
    # Assert that the task description text exists somewhere in the table
    assert context.description in context.target_list.text


@then('the task due time displayed is {due_time}')
def step_impl(context, due_time):
    # Target the task due time HTML element used to display existing due time
    task_due = context.target_task.find_element(By.CLASS_NAME, "task_due")
    if eval(due_time):  # If time is set, check it is not hidden
        assert task_due.is_displayed()
    else:  # If time is unset, check that task due time is hidden
        assert not task_due.is_displayed()

    # Strip ':' from task_due; Check the time value matches due_time
    time_text = str(task_due.text).replace(":", "")
    assert eval(due_time) in time_text
