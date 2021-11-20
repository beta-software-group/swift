@fixture.browser.chrome
@fixture.get.swift.old
Feature: Ability to create recurring tasks

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
            | RECUR: Recur [TEST]   |          | today                |
            | RECUR: Recur [TEST]   | 0100 PM  | today                |
            | RECUR: Recur [TEST]   |          | tomorrow             |
            | RECUR: Recur [TEST]   | 0345 AM  | tomorrow             |
