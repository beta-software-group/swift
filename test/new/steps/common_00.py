from behave import *  # Behave example: https://github.com/behave/behave.example/tree/master/features
from selenium.webdriver.common.by import By
import re
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
    """
    context.list_tab = context.browser.find_element(By.PARTIAL_LINK_TEXT, task_list[1:])
    context.list_tab.click()
    context.task_list = task_list
    context.button_add = context.browser.find_element(By.ID, 'btnAddTask')
    time.sleep(0.25)


@when('task is set to "{description}" due at {due_time}')
def step_impl(context, description, due_time):
    context.button_add.click()
    context.input_description = context.browser.find_element(By.ID, 'new-task-name')
    context.input_description.clear()
    context.input_description.send_keys(description)
    context.description_new = description


@when('the task is saved')
def step_impl(context):
    context.button_add = context.browser.find_element(By.XPATH, '//*[text()=\'Add new task\']')
    context.button_add.click()
    # Wait for page refresh; Initialize WebElement that is (or should be) the task we just saved
    time.sleep(0.25)
    # Only update description when task is saved
    context.description = context.description_new


@then('the task "{description}" is on the page')
def step_impl(context, description):
    # Strip "RECUR:" from description if it is present; Remove any leading whitespace
    context.description = description.removeprefix("RECUR: ").lstrip()
    assert(context.description in context.browser.page_source)
