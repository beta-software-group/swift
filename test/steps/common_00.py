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
    context.input_description.clear()


@when('task is set to "{description}" due at {due_time}')
def step_impl(context, description, due_time):
    context.input_description.send_keys(description)
    context.description = description
    if eval(due_time):  # Only input time if specified in examples for scenario outline; Allows for empty example fields
        context.browser.find_element(By.XPATH, f'//*[@id="time_edit-{context.task_list}"]').click()
        context.browser.find_element(By.ID, f'input-time-{context.task_list}').send_keys(due_time)


@when('the task is saved')
def step_impl(context):
    context.browser.find_element(By.ID, f'save_edit-{context.task_list}').click()


@then('the task "{description}" is on the page')
def step_impl(context, description):
    # Strip "RECUR:" from description if it is present; Remove any leading whitespace
    context.description = description.removeprefix("RECUR: ").lstrip()
    assert(context.description in context.browser.page_source)


@then('the task description is in list "{task_list}"')
def step_impl(context, task_list):
    # Target the task list specified in the examples for the scenario outline
    target_list = context.browser.find_elements(By.XPATH, f'//*[@id="task-list-{task_list}"]/tr')
    # Assert that the task description text exists somewhere in the table
    assert context.description in target_list[-1].text
    context.target_list = target_list


@then('the task due time displayed is {due_time}')
def step_impl(context, due_time):
    # Target the task due time HTML element used to display existing due time
    task_due = context.target_list[-1].find_element(By.CLASS_NAME, "task_due")
    if eval(due_time):  # If time is set, check it is not hidden
        assert task_due.is_displayed()
    else:  # If time is unset, check that task due time is hidden
        assert not task_due.is_displayed()
