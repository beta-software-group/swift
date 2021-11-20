from behave import fixture, use_fixture
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.by import By
import re
import time


def after_step(context, step):
    # After each step, update context.soup with new page_source
    context.soup = BeautifulSoup(context.browser.page_source, 'html.parser')
    time.sleep(2)


def after_scenario(context, step):
    """ Automatically deletes all tasks that contain [TEST] in the description """
    s = BeautifulSoup(context.browser.page_source, 'html.parser')
    # TODO: Refreshing the page removes all task edits, so this isn't needed for now
    for table in s.find_all('table'):
        for row in table.find_all('tr'):
            if not row.find(text=re.compile('\[TEST]')):
                continue
            button_delete = row.find('span', 'delete_task')
            context.browser.find_element(By.ID, button_delete['id']).click()
            time.sleep(0.25)


def before_tag(context, tag):
    """ Run fixtures by parsing tags before 'Scenario', 'Feature' sections of .feature files """
    assert(tag in fixture_registry)
    use_fixture(fixture_registry[tag], context, timeout=10)


# ---------------------------
# Fixtures
# ---------------------------

@fixture
def browser_chrome(context, timeout=30, **kwargs):
    """
    A fixture to define context.browser to use Chrome
    Could easily swap-out browsers for testing or preference
    Example: https://behave.readthedocs.io/en/latest/fixtures.html#realistic-example
    """
    context.browser = webdriver.Chrome()
    context.add_cleanup(context.browser.stop_client)
    return context.browser


@fixture
def visit_swift(context, timeout=30):
    """ Use a fixture to perform a common task between several tests """
    context.browser.get("http://localhost:8080")


@fixture
def visit_old_swift(context, timeout=30):
    """ Use a fixture to perform a common task between several tests """
    context.browser.get("http://localhost:8080/tasks")


# All fixture names stored in a dictionary
# Used for calling fixtures from .feature files by their string key
# See also: before_tag()
fixture_registry = {
    # "fixture.browser.firefox": browser_firefox,
    "fixture.browser.chrome":  browser_chrome,
    "fixture.get.swift.local": visit_swift,
    "fixture.get.swift.old": visit_old_swift,
}
