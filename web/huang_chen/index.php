<!DOCTYPE html>
<html>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="brillantesFiesta2.css" rel="stylesheet" type="text/css">

<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">

<link href="https://fonts.googleapis.com/css?family=Metal+Mania" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Allerta+Stencil">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript" src="./brillantesFiesta_script2.js"></script>
<head>
    <style>

    </style>


</head>

<body>
   <nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>                       
          </button>
         
           <img class="navbar-brand" id="imgA" src="LOGO.png">
            <a id="band" class="navbar-brand" href="#">BRILLANTES FIESTA</a>
        
         

      </div>
      <div>
        <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="#section1">Section 1</a></li>
                <li><a href="#section2">Section 2</a></li>
                <li><a href="#section3">Section 3</a></li>
                <li><a href="#section3">Section 5</a></li>
                <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">Section 4 <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="#section41">Section 4-1</a></li>
                        <li><a href="#section42">Section 4-2</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</div>
</nav> 


<div class="w3-cell-row">
    <div id="section2" class="w3-container w3-red w3-cell">
        <p>Hello W3.CSS Layout.</p>

        <div>
            <img onclick="myMove('img1')" id="img1" src="Logo_no_back.png"> 
        </div>

        <div >
            <img onclick="myMove2('img2')" id="img2" src="Logo_no_back.png">
        </div>

        <div >
            <img onclick="myMove3('img3')" id="img3" src="Logo_no_back.png">
        </div>

        <div >
            <img onclick="myMove('img4')" id="img4" src="Logo_no_back.png">
            
       
        </div>

      
        


    </div>

    <div class="w3-container w3-cell">
        <div id="section1" class="container-fluid">
            <center><h1>Section 1</h1></center>
            <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
            <p>Try to scroll this section and look at the navigation bar while scrolling! Try to scroll this section and look at the navigation bar while scrolling!</p>
            <p>A Tian Tabao la abandonaron sus padres cuando era un bebé. Había nacido tetrapléjica: solo podía mover la cabeza. La mujer que se hizo cargo de ella acabó entregándola a Liming (“Amanecer Brillante”), un orfanato católico para discapacitados en Biancun, una aldea de la provincia de Hebei, en el norte de China. A sus 29 años, Tabao aún vive allí.</p>
             <p>A Tian Tabao la abandonaron sus padres cuando era un bebé. Había nacido tetrapléjica: solo podía mover la cabeza. La mujer que se hizo cargo de ella acabó entregándola a Liming (“Amanecer Brillante”), un orfanato católico para discapacitados en Biancun, una aldea de la provincia de Hebei, en el norte de China. A sus 29 años, Tabao aún vive allí.</p>
        </div>
    </div>
</div>


</div>

<footer class=" w3-center w3-myfont">
    <div class="w3-row-padding" id="foot">
        <div class="w3-col ">
            <div class="w3-col  w3-justify">
                <p><i class="fa fa-fw fa-map-marker"></i> name company</p>
                <i class="fa fa-fw fa-phone"></i> 0044123123 &nbsp;&nbsp;
                <i class="fa fa-fw fa-envelope"></i> ex@mail.com &nbsp;&nbsp;
                <i class="fa fa-fw fa-cc-amex"></i> Amex &nbsp;&nbsp;
                <i class="fa fa-fw fa-credit-card"></i> credit card &nbsp;&nbsp; </p>
                <br>

                <i class="fa fa-facebook-official w3-hover-opacity w3-large"></i>
                <i class="fa fa-instagram w3-hover-opacity w3-large"></i>
                <i class="fa fa-snapchat w3-hover-opacity w3-large"></i>
                <i class="fa fa-pinterest-p w3-hover-opacity w3-large"></i>
                <i class="fa fa-twitter w3-hover-opacity w3-large"></i>
                <i class="fa fa-linkedin w3-hover-opacity w3-large"></i>
            </div>
        </div>
    </footer>

</body>


</html>
