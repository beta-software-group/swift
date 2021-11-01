Feature: Ability to set and display task due times

Scenario: Create a task with due time
    Given we have navigated to http://localhost:8080/
    When we create a new task due at "0100 PM" with "TEST: Due time"
    Then the task description is shown
     And the task due time is shown

Scenario: Create a task with no due time
    Given we have navigated to http://localhost:8080/
    When we create a new task "TEST: No due time"
    Then the task description is shown
     And the task due time is hidden
