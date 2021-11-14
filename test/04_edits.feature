@fixture.browser.chrome
@fixture.get.swift.local
Feature: Ability to edit existing tasks

    Scenario Outline: Task edits are updated correctly
        Given we are creating a new task in "<target_list>"
            And task is set to "<desc>" due at "<due>"
            And the task is saved
        When the task "edit_task" button is pressed
            And task is set to "<new_desc>" due at "<due>"
            And the task "<button>" button is pressed
        Then the task description is in list "<target_list>"
            And the task due time displayed is "<due>"

        Examples:
            |     desc       |   due    |    target_list       |     new_desc     |    button   |
            | Edits [TEST]   | 0100 PM  | today                | New edit [TEST]  |  save_edit  |
            | Edits [TEST]   | 0100 PM  | today                | New edit [TEST]  |  undo_edit  |
            | Edits [TEST]   |          | today                | New edit [TEST]  |  save_edit  |
            | Edits [TEST]   |          | today                | New edit [TEST]  |  undo_edit  |
