from common_00 import *


@then('task is in lists')
def step_impl(context):
    lists = [row["list"] for row in context.table]
    # If the task is recurring, check it appears in all lists
    for l in lists:
        context.execute_steps(u""" 
                then the task description is in list "{list}"
            """.format(list=l))
