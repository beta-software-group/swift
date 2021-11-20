@fixture.browser.chrome
@fixture.get.swift.old
Feature: Ability to set and display task due times

    Scenario Outline: Toggle display of task due time if set
        Given we are creating a new task in "<list>"
        When task is set to "<desc>" due at "<due>"
            And the task is saved
        Then the task description is in list "<list>"
            And the task due time displayed is "<due>"

        Examples:
            |        desc           |   due    |    list    |
            | No due time [TEST]    |          | today      |
            | No due time [TEST]    |          | tomorrow   |
            | Due time [TEST]       | 0100 PM  | tomorrow   |
            | Due time [TEST]       | 0100 PM  | today      |
