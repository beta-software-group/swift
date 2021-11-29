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








</script>

<!DOCTYPE html>
<html>
  <head>
  <title>jQuery UI Referencing</title>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/themes/smoothness/jquery-ui.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"></script>
  <style>
    #Container {
      width: 700px;
      height: 750px;
      margin: 70px auto;
      padding-top: 15px;
      border-radius: 15px;
      
      
    
    }

    .black-border {
      border: 2px solid rgb(0, 0, 0);
    }

    .white-border {
      border: 2px solid rgb(255, 255, 255);
    }

 

    h2 {
      text-align: center;
      
    }

    #projects {
      width: 600px;
      height:600px;
      margin: 0px auto;
     
      
    }

  
    ol li{
      background-color: rgba(211, 210, 210, 0.329);
      border-width: thick;
      font-family: Lato, Times, serif;
      border-radius: 10px;
      cursor: pointer;
      padding:10px;
      margin: 10px auto;
    }

     input[type='checkbox'] { 
       width: 15px;
       height: 15px;
       border-radius: 15px;
       padding: 10px;

      }

    ol li:hover{
      background: rgb(109, 190, 249, .5)
    }

    #btnAddProject{
      margin-left: 540px;
      margin-bottom: 20px;
      font-family: Lato, times, serif;

    }

    #btnAddTask{
      background-color: rgb(189, 88, 70);
      margin-left: 545px;
      margin-top: 20px;
      font-family: Lato, times, serif;
    }

    h2 {
      font-weight: bolder;

    }

    .btnDarkMode {

    margin-bottom: 50px;
  }


  </style>
  <script>
      $(document).ready(function(){
        $("input[type=checkbox]").prop('checked', false); // Uncheck all checkboxes at start
        $("#projects").tabs(); // Gives each project its own tab
        // Make the unordered list sortable in the x-direction (horizontally)
        //$("ul").sortable({axis: "x", containment:"#projects"}); 
        // Within a project, make the tasks sortable in the y-direction (veritically)
        $("ol").sortable({axis: "y",  containment: "#projects"});
        $("#projects").on("click", "input[type=checkbox]", function(){
          $(this).closest("li").slideUp(function(){
            $(this).remove();
          });
          
        });
        
        $('checkbox').change(function() {
         if (this.checked) {
           $(this).parent().css("text-decoration", "line-through");
          } else {
            $(this).parent().parent().css("text-decoration", "none");
          }
         });

        $("#btnAddProject").button() // Makes button servicable
        .click(function(){
          $("#project-dialog").dialog({width:400, resizable:false, modal:true,
              buttons:{
                  "Add new project":function(){
                      // Sets project name to value input into textbox
                      var projectName = $("#new-project").val(); 
                      // Create new list item for new project and append it to the project list
                      $("<li><a href='#" + projectName + "'>" + projectName + "</a></li>")
                      .appendTo("#main");
                      // Add ordered list to the new project
                      $("<ol id='" + projectName + "'></ol>").appendTo("#projects");
                      // Gets number of tabs
                      $("#projects").tabs("refresh"); // Refresh the project list
                      var tabCount = $("#projects .ui-tabs-nav li").length; 
                      // Make the new project the active tab
                      $("#projects").tabs("option", "active", tabCount-1);
                      // Clear value in project textbox
                      $("#new-project").val("");
                      // Close dialog box
                      $(this).dialog("close");


                  }, // Button for adding new project
                  "Cancel":function(){ // Button for canceling 
                      $("#new-project").val(""); // Clears textbox used to input new project name
                      $(this).dialog("close");  // Closes the dialog
                  }


                                       }});
        });
        // Define the service of the add task button
        $("#btnAddTask").button().click(function(){
            $("#task-dialog").dialog({width:400, resizable:false, modal:true,
                buttons:{
                  "Add new task":function(){
                    $("#projects").tabs("refresh"); // Refresh tabs
                      // Gets the new task from the textbox
                      var taskName = $("new-task-name").val();
                      
                      
                      // Get currently active tab
                      var activeTab = $("#projects").tabs("option", "active");
                      var title = $("#main > li:nth-child(" + (activeTab+1) + ") > a")
                      .attr("href");
                      var taskName = $("#new-task-name").val();
                      taskName = "    " + taskName;
                      $("#projects " + title).append(
                        ("<li><input type ='checkbox'>" + taskName + " </li>")
                      )
                      $("#new-task-name").val(""); // Clears task textbox
                      $(this).dialog("close"); // Closes dialogue box

                  },
                  
                  "Cancel":function(){
                      $("#new-task-name").val(""); // Clears task textbox
                      $(this).dialog("close"); // Closes dialogue box

                  }
                }});
        }) 
        /* Parts to temporarily remove
        
      <button id="btnAddProject">Add Project</button>

              <div id= "project-dialog", title="Add a project", style="display:none;">
        <label for="new-project">Project name:</label>
        <input id="new-project" type ="text">
      </div>

      */
      });


  //Script for dark mode
$(document).ready(function(){
    $("button.btnDarkMode").click(function(){

        $("#Container").toggleClass("white-border");
        

        $("button.btnDarkMode").toggleClass("btn-dark");
        $("button.btnDarkMode").toggleClass("btn-white");

        $("body").toggleClass("darkModeBody");

       $("button.btnDarkMode").text($("button.btnDarkMode").text() == 'Dark Mode' ? 'Light Mode' : 'Dark Mode');


        



    });
});












  </script>
  </head>
  <body>
    <div id= "Container" class="black-border">
      <h2>Task Scheduler</h2>

      <div id= "projects">
        <ul id = "main">
          <li><a href= "#personal">Today</a></li>
          <li><a href ="#work">Tomorrow</a></li>
          <li><a href ="#eventually">Eventually</a></li>
        </ul>
        <ol id= "personal">
          <li><input type = "checkbox"> Software Engineering Lecture</li>
          <li><input type = "checkbox"> Present Task Scheduler</li>
          <li><input type = "checkbox"> Eat Dinner</li>
        </ol>
        <ol id= "work">
          <li><input type= "checkbox"> Study for Exam</li>
          <li><input type = "checkbox"> Finish Homework</li>
          <li><input type = "checkbox"> Learn more jQuery</li>
        </ol>
        <ol id= "eventually">
          <li><input type= "checkbox">Change checkbox action to strikethrough and fade</li>
          <li><input type = "checkbox">Display all three tabs simultaneously</li>
          <li><input type = "checkbox">Add times</li>
          <li><input type = "checkbox">Integrate with current Swift Application</li>
        </ol>
      </div>
      <button id= "btnAddTask">Add Task</button>
      <div id="task-dialog", title="Schedule a Task", style="display:none;">
        <label for= "new-task-name">Task name:</label>
        <input id= "new-task-name" type="text">

      </div>

    </div>
  </body>
</html>








<div class="row">


<div class="col">

    <div class="col text-center">
      <button type="button" class="btn btn-dark btnDarkMode center">Dark Mode</button>
    </div>



</div>


</div>

<!-- Hidden input field for holding current key pressed while in text field -->
<input id="current_input" hidden value=""/> 


% include("footer.tpl")
