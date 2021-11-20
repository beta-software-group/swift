@fixture.browser.chrome
@fixture.get.swift.local
Feature: Ability to create and modify tasks

    Scenario Outline: Creation of tasks
        Given we are creating a new task in "<list>"
        When task is set to "<desc>" due at "<due>"
            And the task is saved
        Then the task "<desc>" is on the page

        Examples:
            |        desc           |   due    |    list    |
            | Task creation [TEST]  |          | eventually |
            | Task creation [TEST]  |          | tomorrow   |
            | Task creation [TEST]  |          | today      |
