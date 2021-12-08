<!--<div class="w3-container w3-topbar w3-leftbar w3-rightbar w3-border-white w3-black"> -->
  <!-- <span class="w3-xxxlarge w3-margin"><b>Taskbook </b></span> -->

  <head>
    <!-- Including all libraries -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
  </head>


  <span class="w3-right" hidden>
    <span class="w3-large w3-button w3-margin w3-round-large w3-blue">zzzSign up</span>
    <span class="w3-large w3-button w3-margin w3-round-large w3-blue">Log In</span>
    <span class="w3-large w3-button w3-margin w3-round-large w3-blue">Log Out</span>
  </span>


  <html>
  <link href='https://fonts.googleapis.com/css?family=Cabin+Condensed:700' rel='stylesheet' type='text/css'>
  <!-- Wave text section -->
  <div id="wave" class="" >
   <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
     width="900px" height="240px" xml:space="preserve">
    <defs>
      <pattern id="water" width=".25" height="2.1" patternContentUnits="objectBoundingBox">
        <path fill="#000" d="M0.25,1H0c0,0,0-0.659,0-0.916c0.083-0.303,0.158,0.334,0.25,0C0.25,0.327,0.25,1,0.25,1z"/>
      </pattern>
      
      <text id="text" transform="translate(2,180)" font-family="'Cabin Condensed'" font-size="145">Swift Decisions</text>
      
      <mask id="text-mask">
        <use x="0" y="0" xlink:href="#text" opacity="7" fill="#ffffff"/>
      </mask>
      
      <g id="eff">
        <use x="0" y="0" xlink:href="#text" fill="#1083ad" -webkit-text-stroke-width: 4px;    -webkit-text-stroke-color: #AFFC41;/>
    <rect class="water-fill" mask="url(#text-mask)" fill="url(#water)" x="-300" y="115" width="1200" height="120" opacity="0.3">
      <animate attributeType="xml" attributeName="x" from="-300" to="0" repeatCount="indefinite" dur="2s"/>
    </rect>   
    <rect class="water-fill" mask="url(#text-mask)" fill="url(#water)" y="110" width="1600" height="140" opacity="0.3">
      <animate attributeType="xml" attributeName="x" from="-400" to="0" repeatCount="indefinite" dur="3s"/>
    </rect>  
    <rect class="water-fill" mask="url(#text-mask)" fill="url(#water)" y="120" width="1200" height="120" opacity="0.3">
      <animate attributeType="xml" attributeName="x" from="-300" to="0" repeatCount="indefinite" dur="1.4s"/>
    </rect>  
    <rect class="water-fill" mask="url(#text-mask)" fill="url(#water)" y="120" width="2000" height="120" opacity="0.5">
      <animate attributeType="xml" attributeName="x" from="-500" to="0" repeatCount="indefinite" dur="2.8s"/>
    </rect> 
      </g>
    </defs>
   
      <use xlink:href="#eff" opacity="0.9" style="mix-blend-mode:color-burn"/>
   </svg>
  </div>


<!-- Banner indexing-->
<style>

  #button1 {
   z-index: 50;
  }
 
  #wave {
   z-index: 10;
  }
 
  #text {
   z-index: 10;
  }
 
  </style>
 


<!-- Banner Video --> 
<style>
  header {
    position: relative;
    background-color: black;
    height: 50vh;
    top: -20px;
    min-height: 25rem;
    width: 100%;
    overflow: hidden;
  }

  header video {
    position: absolute;
    top: 34%;
    left: 50%;
    min-width: 100%;
    min-height: 100%;
    width: 50%;
    height: auto;
    z-index: 0;
    -ms-transform: translateX(-50%) translateY(-50%);
    -moz-transform: translateX(-50%) translateY(-50%);
    -webkit-transform: translateX(-50%) translateY(-50%);
    transform: translateX(-50%) translateY(-50%);
  }
  
  header .container {
    position: relative;
    z-index: 1;
  }

  /* Video overlay */
  header .overlay {
    position: absolute;
    top: 0;
    left: 0;
    height: 100%;
    width: 100%;
    background-color: rgb(255, 255, 255);
    opacity: 0.20;
    z-index: 1;
  }
  </style>

<header>
  <!-- This div is intentionally blank. It creates the transparent black overlay over the video.-->
  <div class="overlay"></div>

  <!-- The HTML5 video element that will create the background video on the header -->
  <video playsinline="playsinline" autoplay="autoplay" muted="muted" >
    <source src="https://storage.googleapis.com/coverr-main/mp4/Mt_Baker.mp4" type="video/mp4">
  </video>

  <style>
    div.w3-display-bottommiddle {
      position: relative;
      top: 160px;
      right: 40px;
      width: 35%;
      align-items: center;
      text-align: center;
      opacity: 0.70;
    }
</style>


<style>
  #wave {
    position: absolute;
    top:70px;
    left: 22%;
    align-items: normal;
    text-align: center;
    opacity: 0.80;
    z-index: 9;
  }
</style>



  </header>


