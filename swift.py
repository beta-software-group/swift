# SWIFT Taskbook
# Web Application for Task Management 

# Imports for bottle web application https://bottlepy.org/docs/dev/
from bottle import run, default_app                 # Development server
from bottle import request, response                # Web transaction objects
from bottle import route, get, put, post, delete    # HTML request types
from bottle import template                         # Web page template processor

# Imports for API
import json         # https://docs.python.org/3/library/json.html
import dataset      # https://dataset.readthedocs.io/en/latest/api.html
import time


# ---------------------------
# Web application routes
# ---------------------------

@route('/')
@route('/tasks')
def tasks():
    return template("tasks.tpl")


@route('/login')
def login():
    return template("login.tpl")


@route('/register')
def login():
    return template("register.tpl")


# ---------------------------
# Task API
# ---------------------------

# HTTP Headers
# + https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers
# Documentation on `request` object
# + https://bottlepy.org/docs/0.11/tutorial.html#request-data
# Documentation on `response` object
# + https://bottlepy.org/docs/dev/api.html#the-response-object

taskbook_db = dataset.connect('sqlite:///taskbook.db')


@get('/api/tasks')
def get_tasks():
    """
    Return a list of tasks sorted by submit/modify time
    
    See also: views/tasks.tpl:api_get_tasks()
    See also: views/tasks.tpl:get_current_tasks()
    """
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type
    response.headers['Content-Type'] = 'application/json'
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control
    response.headers['Cache-Control'] = 'no-cache'
    task_table = taskbook_db.get_table('task')
    # Initialize and return dictionary of tasks
    tasks = [dict(x) for x in task_table.find(order_by='time')]
    return {"tasks": tasks}


@post('/api/tasks')
def create_task():
    """
    Create a new task in the database

    Requires the following fields are set by the request
    description - The text description entered in for the task
    list - The text name of the list the task was added to (default lists are "today" and "tomorrow")

    See also: views/tasks.tpl:api_create_task()
    """
    try:  # Validate that the request data is valid for our application
        data = request.json
        for key in data.keys():
            assert key in ["description", "list"], f"Illegal key '{key}'"
        assert type(data['description']) is str, "Description is not a string."
        assert len(data['description'].strip()) > 0, "Description is length zero."
        assert data['list'] in ["today", "tomorrow"], "List must be 'today' or 'tomorrow'"
    except Exception as e:
        # We received a request which either didn't provide correct keys or used incorrect types
        response.status = "400 Bad Request:" + str(e)
        return

    try:  # Attempt to create the task using the validated request data
        task_table = taskbook_db.get_table('task')
        task_table.insert({
            "time": time.time(),
            "description": data['description'].strip(),
            "list": data['list'],
            "completed": False
        })
    except Exception as e:
        response.status = "409 Bad Request:" + str(e)  # 409 conflict

    # Return 200 Success if no errors have been met yet
    response.headers['Content-Type'] = 'application/json'
    return json.dumps({'status': 200, 'success': True})


@put('/api/tasks')
def update_task():
    """
    Update properties of an existing task in the database

    See also: views/tasks.tpl:api_update_task()
    """
    try:  # Validate that the request data is valid for our application
        # https://bottlepy.org/docs/dev/api.html#bottle.BaseRequest.json
        data = request.json
        # We now have a dictionary formatted using key, value pairs parsed from json
        # https://docs.python.org/3/library/stdtypes.html#dict.keys
        for key in data.keys():  # This loop checks that all the keys within json are valid for our db
            assert key in ["id", "description", "completed", "list"], f"Illegal key '{key}'"
        assert type(data['id']) is int, f"id '{id}' is not int"
        # We now know all the keys we need exist, so we can use them without worrying about missing data

        # Assert each key, which we now know exists, uses correct type to match database `tasks` table
        # + Since we know the keys exist, could we just remove these if statements?
        if "description" in request:
            assert type(data['description']) is str, "Description is not a string."
            assert len(data['description'].strip()) > 0, "Description is length zero."
        if "completed" in request:
            assert type(data['completed']) is bool, "Completed is not a bool."
        if "list" in request:
            assert data['list'] in ["today", "tomorrow"], "List must be 'today' or 'tomorrow'"
    except Exception as e:
        # We received a request which either didn't provide correct keys or used incorrect types
        response.status = "400 Bad Request:" + str(e)
        return

    # If the key 'list' exists in the table, update the time to the current time
    # + If it didn't exist, wouldn't the `assert` above have failed? (Can't we remove this?)
    if 'list' in data:
        data['time'] = time.time()

    try:  # Attempt to update the `task` table with the new row using request data that is now in `data`
        task_table = taskbook_db.get_table('task')  # Get the tasks table from the database
        task_table.update(row=data, keys=['id'])    # Update a row in the table using info in `data`
        # + https://dataset.readthedocs.io/en/latest/api.html#dataset.Table.update
    except Exception as e:
        # We failed to update the row within the `task` table (does the table and key exist?)
        response.status = "409 Bad Request:" + str(e)
        return

    # Return 200 Success if no errors have been met yet
    response.headers['Content-Type'] = 'application/json'
    return json.dumps({'status': 200, 'success': True})


@delete('/api/tasks')
def delete_task():
    """
    Delete an existing task in the database using the value of the `id` key in the `task` table

    See also: views/tasks.tpl:api_delete_task()
    """
    try:  # Validate that the request data is valid for our application
        # Parse request data, assert the `id` key is an integer
        data = request.json
        assert type(data['id']) is int, f"id '{id}' is not int"
    except Exception as e:
        # We received a request to delete a row which used an invalid key value (not of type int)
        response.status = "400 Bad Request:" + str(e)
        return

    try:  # Attempt to delete the task (row) from the `task` table using key value of `id`
        task_table = taskbook_db.get_table('task')
        task_table.delete(id=data['id'])
    except Exception as e:
        response.status = "409 Bad Request:" + str(e)
        return

    # Return 200 Success if no errors have been met yet
    response.headers['Content-Type'] = 'application/json'
    return json.dumps({'success': True})


# ---------------------------
# Web application entry point
# ---------------------------

# If you are running on Pythonanywhere
# + See also:  /var/www/shaunrd0_pythonanywhere_com_wsgi.py
application = default_app()
# If you are running locally
if __name__ == "__main__":
    run(host='0.0.0.0', port=8080, debug=True)
