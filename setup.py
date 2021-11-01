import dataset  # https://dataset.readthedocs.io/en/latest/api.html

if __name__ == "__main__":
    taskbook_db = dataset.connect('sqlite:///taskbook.db')
    task_table = taskbook_db.get_table('task')     # Load (or create) the database's 'task' table
    task_table.drop()                              # Delete the old entries in the `task` table
    task_table = taskbook_db.create_table('task')  # Create the 'task' table
    task_table.insert_many([                       # Insert multiple rows (tasks) at one time
        {"time": 0.0, "description": "Do something useful",
         "list": "today", "completed": True, "due": "12:15 PM"},
        {"time": 0.5, "description": "Do something fantastic",
         "list": "today", "completed": False, "due": "05:45 AM"},
        {"time": 0.3, "description": "Do something remarkable",
         "list": "tomorrow", "completed": False, "due": "02:00 PM"},
        {"time": 0.7, "description": "Do something unusual",
         "list": "tomorrow", "completed": True}
    ])
