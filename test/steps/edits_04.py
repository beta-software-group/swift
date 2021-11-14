from common_00 import *


@given('task is set to "{description}" due at {time}')
def step_impl(context, description, time):
    context.execute_steps(u""" 
            When task is set to "{desc}" due at {t}
        """.format(desc=description, t=time))


@given('the task is saved')
def step_impl(context):
    context.execute_steps(u""" 
            When the task is saved  
        """)


@when('the task "{button}" button is pressed')
def step_impl(context, button):
    context.target_task.find_element(By.CLASS_NAME, button).click()
    # Save needed context information depending on which button we pressed
    if button == "edit_task":
        context.input_description = context.target_task.find_element(By.CLASS_NAME, 'task_input')
    elif button == "save_edit":
        # Wait for page refresh; Update target_task and description
        time.sleep(0.25)
        context.target_task = context.target_list.find_element(By.ID, context.task_id)
        # Only update the description when we save the task
        # + context.description is used to assert the task is in the list. description_new is the modified desc
        context.description = context.description_new
    elif button == "undo_edit":
        context.target_task = context.target_list.find_element(By.ID, context.task_id)
        # If we clicked undo_edit don't update description, it should remain the same

