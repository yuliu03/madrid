<!DOCTYPE html>
<html><title>W3.CSS</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">


<head>
  <style type="text/css">
  .mySlides{
    width:100%;
    height: 300px;
  }

  #header {

   /* margin:auto;width:400px;*/
   font-family:Arial, Helvetica, sans-serif;
 }

 ul, ol {
  list-style:none;
}

.nav > li {
  float:left;
  width: 25%;
}

.nav li a {
  background-color:#0982F3;
  color:#fff;
  text-decoration:none;
  padding:10px 12px;
  display:block;
}

.nav li a:hover {
  background-color:#095295;
}

.nav li ul {
  display:none;
  position:absolute;
  min-width:140px;
}

.nav li:hover > ul {
  display:block;
}

.nav li ul li {
  position:relative;
}

.nav li ul li ul {
  right:-100px;
  top:0px;
}
</style>
</head>
<body>


<!-- 
  <div class="w3-panel w3-pale-green" style="height: 500px"> -->
   <div id="header">
     <ul class="nav">
      <li><a href="./catalogo.html">Inicio</a></li>
      <li><a href="">Servicios</a>
       <ul>
        <li><a href="">Submenu1</a></li>
        <li><a href="">Submenu2</a></li>
        <li><a href="">Submenu3</a></li>
        <li><a href="">Submenu4</a>
         <ul>
          <li><a href="">Submenu1</a></li>
          <li><a href="">Submenu2</a></li>
          <li><a href="">Submenu3</a></li>
          <li><a href="">Submenu4</a></li>
        </ul>
      </li>
    </ul>
  </li>
  <li><a href="">Acerca de</a>
   <ul>
    <li><a href="">Submenu1</a></li>
    <li><a href="">Submenu2</a></li>
    <li><a href="">Submenu3</a></li>
    <li><a href="">Submenu4</a></li>
  </ul>
</li>
<li><a href="">Contacto</a></li>
</ul>
</div> 

<div class="w3-content w3-display-container">
  <img class="mySlides" src="w3images/mini.jpg" >
  <img class="mySlides" src="w3images/Diamantes.gif" >
  <img class="mySlides" src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
  <img class="mySlides" src="w3images/diamante.JPG" >

  <button class="w3-button w3-black w3-display-left" onclick="plusDivs(-1)">&#10094;</button>
  <button class="w3-button w3-black w3-display-right" onclick="plusDivs(1)">&#10095;</button>
</div> 
</div>



<!-- Product grid -->
<div class="w3-content w3-display-container">
  <h1>Prueba php</h1>

  <?php
  echo ''
  ?>

  <div class="w3-row " id = "imagenes">
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$19.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$19.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$19.99</b></p>
      </div>
    </div>
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="w3images/Rio-2-Official-Trailer-3-40.jpg" >
        <p>dibujo<br><b>$19.99</b></p>
      </div>
    </div> 
  </div>
</div> 

<script>
var slideIndex = 1;
showDivs(slideIndex);

function plusDivs(n) {
  showDivs(slideIndex += n);
}

function showDivs(n) {
  var i;
  var x = document.getElementsByClassName("mySlides");
  if (n > x.length) {slideIndex = 1}    
    if (n < 1) {slideIndex = x.length}
      for (i = 0; i < x.length; i++) {
       x[i].style.display = "none";  
     }
     x[slideIndex-1].style.display = "block";  
   }
   </script>
 </body>

 </html>

 <!-- -->






