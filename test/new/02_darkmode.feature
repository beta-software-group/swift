@fixture.browser.chrome
@fixture.get.swift.local
Feature: Ability to change themes

    Scenario Outline: Toggle between light and dark mode themes
        Given we are in "<theme>" mode
        When the theme button is clicked
        Then the "<new_theme>" theme is applied

        Examples:
            |  theme  |  new_theme  |
            | dark    | light       |
            | light   | dark        |
