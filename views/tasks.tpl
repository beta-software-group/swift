% include("header.tpl")
% include("banner.tpl")

<style>
  /* Style applied to task due time */
  .task_due {
    font-size: 75%;
    color: #6C757D;
  }

  .time_input {
    height: 22px;
    width: 35%;
  }

  .task_input {
    height: 22px;
    width: 60%;
  }

  .btnDarkMode {
    margin-top: 50px;
  }



.darkModeBody {
  background-color: rgb(41, 41, 41);
  color: #ffffff;
}
 

  /* Force displaying cursor when hovering over task list input field classes */
  .time_edit, .save_edit, .undo_edit, .move_task, .description, .edit_task, .delete_task {
    cursor: pointer;
  }

  /* Style applied to completed tasks */
  .completed {text-decoration: line-through;}
  .description { padding-left:8px }
</style>
<div class="container">



<div class="row">
  <div class="col-sm-12 col-md-6">

    <div class="lineHere w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
      <h1><i>Today</i></h1>
    </div>
    <table id="task-list-today" class="w3-table">
    </table>
    <div class="lineHere w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>
 
</div>



<div class="col-sm-12 col-md-6">
 
    <div class="lineHere w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
      <h1><i>Tomorrow</i></h1>
    </div>
    <table  id="task-list-tomorrow" class="w3-table">
    </table>
    <div class="lineHere w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>

</div>

  </div>


<div class="row">


<div class="col">

    <div class="col text-center">
      <button type="button" class="btn btn-dark btnDarkMode center">Dark Mode</button>
    </div>



</div>


</div>

<!-- Hidden input field for holding current key pressed while in text field -->
<input id="current_input" hidden value=""/> 
<script>

/* API CALLS */

// Call swift.py:get_tasks() using API endpoint and GET request
function api_get_tasks(success_function) {
  $.ajax({url:"api/tasks", type:"GET", 
          success:success_function});
}

// Call swift.py:create_task() using API endpoint and POST request
function api_create_task(task, success_function) {
  console.log("creating task with:", task)
  $.ajax({url:"api/tasks", type:"POST", 
          data:JSON.stringify(task), 
          contentType:"application/json; charset=utf-8",
          success:success_function});
}

// Call swift.py:update_task() using API endpoint and PUT request
function api_update_task(task, success_function) {
  console.log("updating task with:", task)
  task.id = parseInt(task.id)
  $.ajax({url:"api/tasks", type:"PUT", 
          data:JSON.stringify(task), 
          contentType:"application/json; charset=utf-8",
          success:success_function});
}

// Call swift.py:delete_task() using API endpoint and DELETE request
function api_delete_task(task, success_function) {
  console.log("deleting task with:", task)
  task.id = parseInt(task.id)
  $.ajax({url:"api/tasks", type:"DELETE", 
          data:JSON.stringify(task), 
          contentType:"application/json; charset=utf-8",
          success:success_function});
}

/* KEYPRESS MONITOR */

// Tracks the current key being pressed and which element is receiving input
function input_keypress(event) {
  console.log("Keypress: " + event.target.id)

  // If we are inputting text into a target field that is not match the current_input
  // + https://api.jquery.com/val/
  if (event.target.id != $("#current_input").val()) {
    console.log("Current input (" + $("#current_input").val() + ") "
              + "does not match field recieving input: " + event.target.id)
    $("#current_input").val(event.target.id)
  }
  // Get the `id` for the target that is receiving input
  // + Input field for task 4 has id=input-4, so this would be 4
  id = event.target.id.replace("input-","");

  // Set properties of elements using HTML the id attribute as selector
  // + https://api.jquery.com/prop/
  // Hide `...` symbol and time input field
  $("#filler-"+id).prop('hidden', true);
  $("#input-time-"+id).prop('hidden', true);
  // Show time, save, undo buttons
  $("#time_edit-"+id).prop('hidden', false);
  $("#save_edit-"+id).prop('hidden', false);
  $("#undo_edit-"+id).prop('hidden', false);
}

/* EVENT HANDLERS */

function move_task(event) {
  // If any other task is currently being edited, do nothing
  if ($("#current_input").val() != "") { return }
  console.log("move item", event.target.id )
  id = event.target.id.replace("move_task-",""); // Get the id of the task as a plain integer

  // Check which list we want to assign the task to
  // + If the target has the HTML class "today", we must want to move it to "tomorrow"
  target_list = event.target.className.search("today") > 0 ? "tomorrow" : "today";
  // Move the task; If we succeed call get_current_tasks() to update the list
  api_update_task(
    { /* Task move data */
      'id': id,
      'list': target_list,
      'due': convert_time($("#task-due-"+id).text())
    },
    function(result) {
      console.log(result);
      get_current_tasks();
    }
  );
}

function complete_task(event) {
  // If any other task is currently being edited, do nothing
  if ($("#current_input").val() != "") { return }
  console.log("complete item", event.target.id )
  // Get the id of the task as a plain integer
  id = event.target.id.replace("description-","");

  // Check if target has the HTML class "completed" applied
  completed = event.target.className.search("completed") > 0;
  console.log("updating :",{'id':id, 'completed':completed==false})
  // Mark the task completed; If we succeed call get_current_tasks() to update the list
  api_update_task(
    { /* Task complete data */
      'id': id,
      'completed': completed==false,
      'due': convert_time($("#task-due-"+id).text())
    },
    function(result) {
      console.log(result);
      get_current_tasks();
    }
  );
}

// Called when edit button is clicked
function edit_task(event) {
  // If any other task is currently being edited, do nothing
  if ($("#current_input").val() != "") { return }
  console.log("edit item", event.target.id)
  id = event.target.id.replace("edit_task-",""); // Get the id of the task as a plain integer

  // Set the contents of the input field to match task description
  $("#input-"+id).val($("#description-"+id).text());
  // Hide task description, move, edit, and delete buttons
  $("#description-"+id).prop('hidden', true);
  $("#move_task-"+id).prop('hidden', true);
  $("#edit_task-"+id).prop('hidden', true);
  $("#delete_task-"+id).prop('hidden', true);
  $("#editor-"+id).prop('hidden', false); // Show task input field

  // Time input
  // Use helper function to find default value for time input field using task-due element
  scheduled = $("#task-due-"+id).text() != "";
  if (scheduled) {
    // Show the time edit field on tasks that are scheduled; Initialize its value to due time
    // + .val() on HTML time input field requires 24H formatted string (HH:MM)
    $("#input-time-"+id).val(convert_time($("#task-due-"+id).text()));
    $("#input-time-"+id).prop('hidden', false);
  } else {
    $("#input-time-"+id).prop('hidden', true);
  }
  $("#task-due-"+id).prop("hidden", true) // Always hide task due time when editing

  // Show time, save, undo buttons
  $("#time_edit-"+id).prop('hidden', false);
  $("#save_edit-"+id).prop('hidden', false);
  $("#undo_edit-"+id).prop('hidden', false);

  // Flag this task's id as the task we are editing
  // + Blocks us from editing multiple tasks at once
  $("#current_input").val(event.target.id)
}

// Called when the task time edit button is clicked
function time_edit(event) {
  id = event.target.id.replace("time_edit-","") // Get the id of the task as a plain integer
  console.log("edit time", id)
  time_input = "#input-time-" + id

  $(time_input).prop('hidden', !$(time_input).prop('hidden'))
}

// Called when an edit is saved
// + Also called when a new task is input and saved
function save_edit(event) {
  console.log("save item", event.target.id)
  id = event.target.id.replace("save_edit-",""); // Get the id of the task as a plain integer
  console.log("desc to save = ",$("#input-" + id).val())
  console.log("due time to save = ", $("#input-time-" + id).val())

  // If the time input is not hidden, the task is scheduled; Show due time
  is_scheduled = !$("#input-time-"+id).prop("hidden")
  $("#task-due-"+id).prop("hidden", is_scheduled)

  // If the task we are saving already exists
  if ((id != "today") & (id != "tomorrow")) {
    api_update_task(
      { /* Updated task data */
        'id': id,
         description: $("#input-" + id).val(),
         due: is_scheduled ? $("#input-time-"+id).val() : ""
      },
      function(result) {
        console.log(result);
        get_current_tasks();
        $("#current_input").val("")
      }
    );
  } else { // If the task we are saving is a new task
    api_create_task(
      { /* New task data */
        description: $("#input-" + id).val(),
        list: id,
        due: is_scheduled ? $("#input-time-"+id).val() : ""
      },
      function(result) {
        console.log(result);
        get_current_tasks();
        $("#current_input").val("")
      }
    );
  }
}

// Called when the X button is clicked
function undo_edit(event) {
  id = event.target.id.replace("undo_edit-","") // Get the id of the task as a plain integer
  console.log("undo",id)

  // Reset the input field for this task
  $("#input-" + id).val("");
  // Don't toggle buttons for new task input fields with the id "input-today" or "input-tomorrow"
  if ((id != "today") & (id != "tomorrow")) {
    // Only show task due time when there is a value in the task-due field
    $("#task-due-"+id).prop("hidden", $("#task-due-"+id).text() == "")

    // Hide text field, save and undo buttons
    $("#editor-"+id).prop('hidden', true);
    $("#time_edit-"+id).prop('hidden', true);

    $("#save_edit-"+id).prop('hidden', true);
    $("#undo_edit-"+id).prop('hidden', true);
    // Show task description, move, edit, and delete buttons
    $("#move_task-"+id).prop('hidden', false);
    $("#description-"+id).prop('hidden', false);
    $("#filler-"+id).prop('hidden', false);
    $("#edit_task-"+id).prop('hidden', false);
    $("#delete_task-"+id).prop('hidden', false);
  }
  $("#input-time-"+id).prop('hidden', true); // Always hide time input field

  // set the editing flag
  $("#current_input").val("")
}

function delete_task(event) {
  // If any other task is currently being edited, do nothing
  if ($("#current_input").val() != "") { return }
  console.log("delete item", event.target.id )
  // Get the id of the task as a plain integer
  id = event.target.id.replace("delete_task-","");

  // Delete the task; If we succeed call get_current_tasks() to update the list
  api_delete_task(
    { /* Task delete data */
      'id':id
    },
    function(result) {
      console.log(result);
      get_current_tasks();
    }
  );
}

// Called for each task individually. x contains values from a single row in the DB
function display_task(x) {
  arrow = (x.list == "today") ? "arrow_forward" : "arrow_back";
  // If the task has been completed, make sure the `completed` HTML class is applied 
  completed = x.completed ? " completed" : ""; // Space before `completed` is required

  // When we display a task, check if it's `id` matches "today" or "tomorrow" exactly
  // + If it does, this task represents the input field for adding new tasks
  if ((x.id == "today") | (x.id == "tomorrow")) { // Display the input fields for adding new tasks
    // Tasks that hold input fields for creating new tasks are assigned HTML id=task-<LIST_NAME>
    t = '<tr id="task-'+x.id+'" class="task">' +
        '  <td style="width:36px"></td>' +  
        '  <td><span id="editor-'+x.id+'">' +
        '        <input id="input-'+x.id+'" class="task_input" ' +
        '          type="text" autofocus placeholder="Add an item..."/>'+
        '        <input hidden id="input-time-'+x.id+'" class="time_input" type="time" value="12:00"/>' +
        '      </span>' + 
        '  </td>' +

        // HTML for task creator buttons
        '  <td style="width:100px">' +
        '    <span id="filler-'+x.id+'" class="material-icons">more_horiz</span>' +  // Draw the `...` symbol
        // Hide the Save and Undo icons by default; Icons can be toggled by using task id with jQuery .prop()
        // + See also: input_keypress()
        '    <span id="time_edit-'+x.id+'" hidden class="time_edit material-icons">schedule</span>' +
        '    <span id="save_edit-'+x.id+'" hidden class="save_edit material-icons">done</span>' +
        '    <span id="undo_edit-'+x.id+'" hidden class="undo_edit material-icons">cancel</span>' +
        '  </td>' +
        '</tr>';
  } else { // Display an existing task
    t = '<tr id="task-'+x.id+'" class="task">' + 
        '  <td><span id="move_task-'+x.id+'" class="move_task '+x.list+' material-icons">' + arrow + '</span></td>' +
        '  <td><span id="description-'+x.id+'" class="description' + completed + '">' + x.description + '</span>' + 
        // If the task is scheduled, remove the hidden attribute; If the due time is null set text content to empty string
        '      <span id="task-due-'+x.id+'" class="task_due' + completed + '">' + (x.due != null ? x.due : "") + '</span>' +
        '      <span id="editor-'+x.id+'" hidden>' + 
        '        <input id="input-'+x.id+'" class="task_input" type="text" autofocus/>' +
        '        <input id="input-time-'+x.id+'" class="time_input" type="time" value="12:00"/>' +
        '      </span>' + 
        '  </td>' +

        // HTML for task buttons
        '  <td>' +
        // Show the Edit and Delete icons by default
        '    <span id="edit_task-'+x.id+'" class="edit_task '+x.list+' material-icons">edit</span>' +
        '    <span id="delete_task-'+x.id+'" class="delete_task material-icons">delete</span>' +
        // Hide the Save and Undo icons by default; Icons can be toggled by referencing task id with jQuery .prop()
        // + See also: edit_task()
        '    <span id="time_edit-'+x.id+'" hidden class="time_edit material-icons">schedule</span>' +
        '    <span id="save_edit-'+x.id+'" hidden class="save_edit material-icons">done</span>' + 
        '    <span id="undo_edit-'+x.id+'" hidden class="undo_edit material-icons">cancel</span>' +
        '  </td>' +
        '</tr>';
  } // Local variable `t` now holds HTML content of the new task, using the data from `x`

  // Append HTML for the new task into list it's assigned to
  // + https://api.jquery.com/append/
  $("#task-list-" + x.list).append(t);

  // TODO: Couldn't this happen in get_current_tasks once, instead of for each task?
  // Empty the current_input field
  $("#current_input").val("")
}

// Displays all tasks
function get_current_tasks() {
  // Remove all tasks so we can create an updated task list
  $(".task").remove();
  // Create two tasks with id=today and id=tomorrow
  // + These IDs will display new task input fields within display_task()
  display_task({id: "today", list: "today"})
  display_task({id: "tomorrow", list: "tomorrow"})

  // display the tasks
  api_get_tasks(
    function(result){
      for (const task of result.tasks) {
        display_task(task);
        if ($("#task-due-"+task.id).text != "") { // Check if we should display task due time
          $("#task-due-"+task.id).prop("hidden", false)
        }
        else {
          $("#task-due-"+task.id).prop("hidden", true)
        }
      }

      // Set click events for elements with HTML classes 
      // + Each of these *_task() functions call an api_*_task() function to interface with swift.py
      $(".move_task").click(move_task);
      $(".description").click(complete_task)
      $(".edit_task").click(edit_task);
      $(".time_edit").click(time_edit);
      $(".save_edit").click(save_edit);
      $(".undo_edit").click(undo_edit);
      $(".delete_task").click(delete_task);

      // Set all input HTML elements to call input_keypress when key is pressed
      $("input").keypress(input_keypress);
    }
  );
}

/* HELPER FUNCTIONS */

// Converts from 24H time (HH:MM) into 12H (HH:MM AM/PM)
// Expects text string in 24H format (HH:MM)
function convert_time(text) {
  if (text == "") return text;
  result = text.substring(0, 5);
  if (text.substring(6, 8) == "PM" && parseInt(result) != 12) {
    result = (parseInt(result) + 12) + ":" + result.substring(3, 5)
  }
  return result;
}

// Get the current tasks from the DB when the page begins loading
$(document).ready(function() {
  get_current_tasks()
});



$(document).ready(function(){
    $("button.btnDarkMode").click(function(){

        $("div.lineHere").toggleClass("w3-border-black");
        $("div.lineHere").toggleClass("w3-border-white");

        $("button.btnDarkMode").toggleClass("btn-dark");
        $("button.btnDarkMode").toggleClass("btn-white");

        $("body").toggleClass("darkModeBody");

       $("button.btnDarkMode").text($("button.btnDarkMode").text() == 'Dark Mode' ? 'Light Mode' : 'Dark Mode');


        



    });
});







</script>
% include("footer.tpl")
