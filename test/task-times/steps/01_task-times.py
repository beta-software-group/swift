from behave import *  # Behave example: https://github.com/behave/behave.example/tree/master/features
from selenium import webdriver
from selenium.webdriver.common.by import By


@given('we have navigated to {url}')
def step_impl(context, url):
    browser = webdriver.Chrome()
    browser.get(url)
    context.browser = browser


@when('we create a new task due at {time} with {description}')
def step_impl(context, time, description):
    """
    Scenario: Create a task with due time
        Given we have navigated to http://localhost:8080/
        When we create a new task due at "0100 PM" with "TEST: Due time"
        Then the task description is shown
         And the task due time is shown
    """
    input_description = context.browser.find_element(By.ID, "input-today")
    button_save = context.browser.find_element(By.ID, "save_edit-today")
    input_time = context.browser.find_element(By.ID, "input-time-today")
    input_description.clear()
    input_description.send_keys(description)
    context.browser.find_element(By.XPATH, "//*[@id='time_edit-today']").click()
    input_time.send_keys(time)
    button_save.click()
    context.description = description


@when('we create a new task {description}')
def step_impl(context, description):
    """
    Scenario: Create a task with no due time
        Given we have navigated to http://localhost:8080/
        When we create a new task "TEST: No due time"
        Then the task description is shown
         And the task due time is hidden
    """
    input_description = context.browser.find_element(By.ID, "input-today")
    button_save = context.browser.find_element(By.ID, "save_edit-today")
    input_description.clear()
    input_description.send_keys(description)
    context.description = description
    button_save.click()


@then('the task description is shown')
def step_impl(context):
    list_today = context.browser.find_elements(By.XPATH, "//*[@id='task-list-today']/tr")
    assert context.description in list_today[-1].text
    context.list_today = list_today


@then('the task due time is hidden')
def step_impl(context):
    task_due = context.list_today[-1].find_element(By.CLASS_NAME, "task_due")
    button_delete = context.list_today[-1].find_element(By.CLASS_NAME, "delete_task")
    assert not task_due.is_displayed()
    button_delete.click()


@then('the task due time is shown')
def step_impl(context):
    task_due = context.list_today[-1].find_element(By.CLASS_NAME, "task_due")
    button_delete = context.list_today[-1].find_element(By.CLASS_NAME, "delete_task")
    assert task_due.is_displayed()
    button_delete.click()
