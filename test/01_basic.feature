@fixture.browser.chrome
@fixture.get.swift.local
Feature: Ability to create and modify tasks
# TODO: Write tests for editing tasks

    Scenario Outline: Creation of tasks
        Given we are creating a new task in "<list>"
        When task is set to "<desc>" due at "<due>"
            And the task is saved
        Then the task description is in list "<list>"

        Examples:
            |        desc           |   due    |    list    |
            | Task creation [TEST]  |          | tomorrow   |
            | Task creation [TEST]  |          | today      |
