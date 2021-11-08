<!--<div class="w3-container w3-topbar w3-leftbar w3-rightbar w3-border-white w3-black">-->
  <!-- <span class="w3-xxxlarge w3-margin"><b>Taskbook </b></span> -->

  <span class="w3-right" hidden>
    <span class="w3-large w3-button w3-margin w3-round-large w3-blue">zzzSign up</span>
    <span class="w3-large w3-button w3-margin w3-round-large w3-blue">Log In</span>
    <span class="w3-large w3-button w3-margin w3-round-large w3-blue">Log Out</span>
  </span>


<!-- Banner Video --> 
<style>
  header {
    position: relative;
    background-color: black;
    height: 40vh;
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
    background-color: black;
    opacity: 0.20;
    z-index: 1;
  }
  </style>
  

  <header>
    <!-- This div is intentionally blank. It creates the transparent black overlay over the video.-->
    <div class="overlay"></div>
  
    <!-- The HTML5 video element that will create the background video on the header -->
    <video playsinline="playsinline" autoplay="autoplay" muted="muted" loop="loop">
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

    <!-- The header content -->
    <div class="container h-100">
      <div class="d-flex h-200 text-center align-items-center">
          <div class="w3-display-bottommiddle w3-large w3-topbar w3-leftbar w3-rightbar w3-bottombar w3-border-white w3-black">
            <span class="w3-xxlarge w3-margin "><b> Swift Decisions </b></span>
          </div>
      </div>
    </div>
  </header>


