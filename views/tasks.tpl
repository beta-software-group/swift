% include("header.tpl")
% include("banner.tpl")

<style>
  /* Force displaying cursor when hovering over task list input field classes */
  .save_edit, .undo_edit, .move_task, .description, .edit_task, .delete_task {
    cursor: pointer;
  }
  /* Style applied to completed tasks */
  .completed {text-decoration: line-through;}
  .description { padding-left:8px }
</style>

<div class="w3-row">
  <div class="w3-col s6 w3-container w3-topbar w3-bottombar w3-leftbar w3-rightbar w3-border-white">
    <div class="w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
      <h1><i>Today</i></h1>
    </div>
    <table id="task-list-today" class="w3-table">
    </table>
    <div class="w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>
  </div>

  <div class="w3-col s6 w3-container w3-topbar w3-bottombar w3-leftbar w3-rightbar w3-border-white">
    <div class="w3-row w3-xxlarge w3-bottombar w3-border-black w3-margin-bottom">
      <h1><i>Tomorrow</i></h1>
    </div>
    <table  id="task-list-tomorrow" class="w3-table">
    </table>
    <div class="w3-row w3-bottombar w3-border-black w3-margin-bottom w3-margin-top"></div>
  </div>
</div>

<!-- Hidden input field for holding current key pressed while in text field -->
<input id="current_input" hidden value=""/> 
<script>
// Useful resources:
// JQuery basic syntax https://www.w3schools.com/jquery/jquery_syntax.asp
// Material Icons index https://fonts.google.com/icons?selected=Material+Icons
// Also see views/header.tpl


/* INITIALIZATION */

// Get the current tasks from the DB when the page begins loading
$(document).ready(function() {
  get_current_tasks()
});


/* TASK DISPLAY */

// Called for each task individually
function display_task(x) {
  arrow = (x.list == "today") ? "arrow_forward" : "arrow_back";
  // If the task has been completed, make sure the `completed` HTML class is applied 
  completed = x.completed ? " completed" : ""; // Space before `completed` is required

  // When we display a task, check if it's `id` matches "today" or "tomorrow" exactly
  // + If it does, this task represents the input field for adding new tasks
  if ((x.id == "today") | (x.id == "tomorrow")) { // Display the input fields for adding new tasks
    // Tasks that hold input fields for creating new tasks are assigned HTML id=task-<LIST_NAME>
    // + The acual input field holds HTML id=input<TASK_ID>
    t = '<tr id="task-'+x.id+'" class="task">' +
        '  <td style="width:36px"></td>' +  
        '  <td><span id="editor-'+x.id+'">' + 
        '        <input id="input-'+x.id+'" style="height:22px" class="w3-input" '+ 
        '          type="text" autofocus placeholder="Add an item..."/>'+
        '      </span>' + 
        '  </td>' +
        '  <td style="width:72px">' +
        '    <span id="filler-'+x.id+'" class="material-icons">more_horiz</span>' + 
        // Hide the Save and Undo icons by default; Icons can be toggled by refrencing task id with jQuery .prop()
        // + See also: input_keypress()
        '    <span id="save_edit-'+x.id+'" hidden class="save_edit material-icons">done</span>' +
        '    <span id="undo_edit-'+x.id+'" hidden class="undo_edit material-icons">cancel</span>' +
        '  </td>' +
        '</tr>';
  } else { // Display the task in view mode (it has an id=task-<INT>)
    // Tasks are assigned HTML id=task-<INT>
    t = '<tr id="task-'+x.id+'" class="task">' + 
        '  <td><span id="move_task-'+x.id+'" class="move_task '+x.list+' material-icons">' + arrow + '</span></td>' +
        '  <td><span id="description-'+x.id+'" class="description' + completed + '">' + x.description + '</span>' + 
        '      <span id="editor-'+x.id+'" hidden>' + 
        '        <input id="input-'+x.id+'" style="height:22px" class="w3-input" type="text" autofocus/>' +
        '      </span>' + 
        '  </td>' +
        '  <td>' +
        // Show the Edit and Delete icons by default
        '    <span id="edit_task-'+x.id+'" class="edit_task '+x.list+' material-icons">edit</span>' +
        '    <span id="delete_task-'+x.id+'" class="delete_task material-icons">delete</span>' +
        // Hide the Save and Undo icons by default; Icons can be toggled by refrencing task id with jQuery .prop()
        // + See also: edit_task()
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
  display_task({id:"today", list:"today"})
  display_task({id:"tomorrow", list:"tomorrow"})

  // display the tasks
  api_get_tasks(function(result){
    for (const task of result.tasks) {
      display_task(task);
    }
    
    // Set click events for elements with HTML classes 
    // + Each of these *_task() functions call an api_*_task() function to interface with swift.py
    $(".move_task").click(move_task);
    $(".description").click(complete_task)
    $(".edit_task").click(edit_task);
    $(".save_edit").click(save_edit);
    $(".undo_edit").click(undo_edit);
    $(".delete_task").click(delete_task);

    // Set all input HTML elements to call input_keypress when key is pressed
    $("input").keypress(input_keypress);
  });
}


/* KEYPRESS MONITOR */

// Tracks the current key being pressed and which element is receiving input
function input_keypress(event) {
  console.log("Keypress: " + event.target.id)
  
  // If we are inputting text into a target field that is not match the current_input
  // + https://api.jquery.com/val/
  // TODO: This condition is wrong, it should be:
  //       if (event.target.id != $("#current_input").val()) {
  if (event.target.id != "current_input") {
    console.log("Current input (" + $("#current_input").val() + ") "
              + "does not match field recieving input: " + event.target.id)
    $("#current_input").val(event.target.id)
  }
  // Get the `id` for the target that is receiving input
  // + Input field for task 4 has id=input-4, so this would be 4
  id = event.target.id.replace("input-","");

  // Set properties of elements using HTML the id attribute as selector
  // + https://api.jquery.com/prop/
  $("#filler-"+id).prop('hidden', true);
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
  api_update_task({'id':id, 'list':target_list},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function complete_task(event) {
  // If any other task is currently being edited, do nothing
  if ($("#current_input").val() != "") { return }
  console.log("complete item", event.target.id )
  id = event.target.id.replace("description-",""); // Get the id of the task as a plain integer

  // Check if target has the HTML class "completed" applied
  completed = event.target.className.search("completed") > 0;
  console.log("updating :",{'id':id, 'completed':completed==false})
  // Mark the task completed; If we succeed call get_current_tasks() to update the list
  api_update_task({'id':id, 'completed':completed==false}, 
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
}

function delete_task(event) {
  // If any other task is currently being edited, do nothing
  if ($("#current_input").val() != "") { return }
  console.log("delete item", event.target.id )
  id = event.target.id.replace("delete_task-",""); // Get the id of the task as a plain integer

  // Delete the task; If we succeed call get_current_tasks() to update the list
  api_delete_task({'id':id},
                  function(result) { 
                    console.log(result);
                    get_current_tasks();
                  } );
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
  $("#move_task-"+id).prop('hidden', true);
  $("#description-"+id).prop('hidden', true);
  $("#edit_task-"+id).prop('hidden', true);
  $("#delete_task-"+id).prop('hidden', true);
  // Show text field, save and undo buttons
  $("#editor-"+id).prop('hidden', false);
  $("#save_edit-"+id).prop('hidden', false);
  $("#undo_edit-"+id).prop('hidden', false);

  // Flag this task's id as the task we are editing
  // + Blocks us from editing multiple tasks at once
  $("#current_input").val(event.target.id)
}

// Called when an edit is saved
// + Also called when a new task is input and saved
function save_edit(event) {
  console.log("save item", event.target.id)
  id = event.target.id.replace("save_edit-",""); // Get the id of the task as a plain integer
  console.log("desc to save = ",$("#input-" + id).val())

  // If the task we are saving already exists
  if ((id != "today") & (id != "tomorrow")) {
    api_update_task({'id':id, description:$("#input-" + id).val()},
                    function(result) { 
                      console.log(result);
                      get_current_tasks();
                      $("#current_input").val("")
                    } );
  } else { // If the task we are saving is a new task
    api_create_task({description:$("#input-" + id).val(), list:id},
                    function(result) { 
                      console.log(result);
                      get_current_tasks();
                      $("#current_input").val("")
                    } );
  }
}

// Called when you edit an item and then click the X instead of saving the changes
// + Also called when a new task is input and the X button is pressed
function undo_edit(event) {
  id = event.target.id.replace("undo_edit-","") // Get the id of the task as a plain integer
  console.log("undo",id)

  // Reset the input field for this task
  $("#input-" + id).val("");
  // Don't toggle buttons for new task input fields with the id "input-today" or "input-tomorrow"
  if ((id != "today") & (id != "tomorrow")) {
    // Hide text field, save and undo buttons
    $("#editor-"+id).prop('hidden', true);
    $("#save_edit-"+id).prop('hidden', true);
    $("#undo_edit-"+id).prop('hidden', true);
    // Show task description, move, edit, and delete buttons
    $("#move_task-"+id).prop('hidden', false);
    $("#description-"+id).prop('hidden', false);
    $("#filler-"+id).prop('hidden', false);
    $("#edit_task-"+id).prop('hidden', false);
    $("#delete_task-"+id).prop('hidden', false);
  }
  // set the editing flag
  $("#current_input").val("")
}


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

</script>

% include("footer.tpl")
