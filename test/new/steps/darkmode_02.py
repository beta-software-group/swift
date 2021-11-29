from common_00 import *


@given('we are in "{theme}" mode')
def step_impl(context, theme):
    context.body = context.browser.find_element(By.TAG_NAME, 'body')
    context.container = context.browser.find_element(By.ID, 'Container')
    context.theme_button = context.browser.find_element(By.CLASS_NAME, 'btnDarkMode')

    # Page applies light theme by default, so if another is requested apply it first
    if theme == "dark":
        context.theme_button.click()
        time.sleep(0.25)


@when("the theme button is clicked")
def step_impl(context):
    context.theme_button.click()
    time.sleep(0.25)


@then('the "{new_theme}" theme is applied')
def step_impl(context, new_theme):
    if new_theme == "light":
        assert " darkModeBody" not in context.body.get_dom_attribute('class')
        assert " white-border" not in context.container.get_dom_attribute('class')
        assert " btn-dark" in context.theme_button.get_dom_attribute('class')
        assert "Dark Mode" == context.theme_button.text
    elif new_theme == "dark":
        assert " darkModeBody" in context.body.get_dom_attribute('class')
        assert " white-border" in context.container.get_dom_attribute('class')
        assert " btn-white" in context.theme_button.get_dom_attribute('class')
        assert "Light Mode" == context.theme_button.text
