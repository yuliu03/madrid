<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Theme Made By www.w3schools.com - No Copyright -->
  <title>Bootstrap Theme Company Page</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link href="https://fonts.googleapis.com/css?family=Montserrat" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Lato" rel="stylesheet" type="text/css">
  <link href='http://fonts.googleapis.com/css?family=Julius+Sans+One' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" href="css/main.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


  <style>
    img{
      /*border: 5px solid red;*/
      margin:0px;
      padding:0px;

    }

    .fotos{
      float: left;
     /* border: 5px solid green;*/
      margin-top: 20px;
      width: 20%;
      padding: 0px;

    }



  </style>
  <!--  <body id="myPage" data-spy="scroll" data-target=".navbar" data-offset="60"> -->
  <body>
    <!-- navegador lateral-->
       <!-- <div class="w3-sidebar w3-bar-block w3-black w3-xlarge" style="width:70px;">
        <a href="#" class="w3-bar-item w3-button"><i class="fa fa-home"></i></a> 
        <a href="#" class="w3-bar-item w3-button"><i class="fa fa-search"></i></a> 
        <a href="#" class="w3-bar-item w3-button"><i class="fa fa-envelope"></i></a> 
        <a href="#" class="w3-bar-item w3-button"><i class="fa fa-globe"></i></a>
        <a href="#" class="w3-bar-item w3-button"><i class="fa fa-trash"></i></a> 
      </div>  -->


      <!-- navbar-fixed-top -->
      <nav class="navbar navbar-default "  style="background-color: white">
        <div class="container">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>                        
            </button>
            <a class="navbar-brand" href="#myPage"><p style="color: black">Logo</p></a>
          </div>
          <div class="collapse navbar-collapse" id="myNavbar">
            <ul class="nav navbar-nav navbar-right">
              <li><a href="#segunda">Quien Somos</a></li>
              <li><a href="#services">Sevicio</a></li>
              <li><a href="#portfolio">Noticia</a></li>
              <li><a href="#pricing">Enlace</a></li>
              <li><a href="#contact">Contactamos</a></li>
            </ul>
          </div>
        </div>
      </nav>  

      <!-- ini primer panel -->
      <div class="jumbotron">

        <div class="text-center">
        <!--  <h1>欧乘房产</h1> 
        <p>CR.HOMES</p>  -->
        <center>
         <br><br><br><br><br><br><br><br>

         <form>
          <div class="input-group"  style="width:50%">
            <input  type="email" class="form-control" size="50" placeholder="Email Address" required>
            <div class="input-group-btn">
              <button type="button" class="btn btn-danger">Subscribe</button>
            </div>
          </div>
        </form> 
      </center>

    </div>




    <div class="w3-dropdown-hover" > 
      <br><br>
      <button class="w3-button w3-white ">Idioma</button>
      <div class="w3-dropdown-content w3-bar-block w3-border">
        <a href="#" class="w3-bar-item w3-button" ">Español <img src="./imagen/l_es.jpg" style="width:30px; float: right;"></a>
        <a href="#" class="w3-bar-item w3-button">Engles 2</a>
        <a href="#" class="w3-bar-item w3-button">Chino 3</a>
      </div>
      <br><br>
    </div>

    <!-- slider -->

    <div id="capa2" class="panel"><!-- ini capa2-->
      <HEADER>

        <!-- <ul  class="nav nav-pills " > -->
        <ul  class="nav">
          <li class="active" style="float:left">
            <a  href="#1b" data-toggle="tab" class="w3-button w3-red ">Overview</a>
          </li>
          <li style="float: left"><a href="#2b" data-toggle="tab" class="w3-button w3-teal ">Using nav-pills</a>
          </li>
          <li style="float: left"><a href="#3b" data-toggle="tab" class="w3-button w3-purple ">Applying clearfix</a>
          </li>
          <li style="float: left"><a href="#4b" data-toggle="tab" class="w3-button w3-lime ">Background color</a>
          </li>
        </ul>
      </HEADER>

      <BODY>
        <div id="capa3" ><!-- ini capa3 -->
          <!--  class="container-fluid"  -->
          <!--  <div id="segunda" > --> <!--  parte2-->
          <!--   <div id="exTab3" class="container"  > --> <!-- style="margin:auto;" -->

          <div class="tab-content clearfix">
            <div class="tab-pane active" id="1b">
              <div class="fotos" id="fila1"><img src="./imagen/p1.png" style="width:50%"><br> 
                <p>fila 1</p>
              </div> 
              <div class="fotos" id="fila2"><img src="./imagen/p1.png" style="width:50%"><br>  <p>fila 1</p></div>
              <div class="fotos" id="fila3"><img src="./imagen/p1.png" style="width:50%"><br> <p>fila 1</p></div>
              <div class="fotos" id="fila4"><img src="./imagen/p1.png" style="width:50%"><br> <p>fila 1</p></div>

              <!-- Product grid -->


        <!--  <div class="w3-row">
          <br><br><br>
          <div class="w3-col l3 s6">
            <div class="w3-container">
              <img src="./imagen/p1.png" style="width:20%">
              <p style="color:black ; margin-top: 20px">home</p><br>
            </div>
            <div class="w3-container">
              <img src="./imagen/home.png" style="width:20%">
              <p>home<br><b>$24.99</b></p>
            </div>
          </div>

          <div class="w3-col l3 s6">
            <div class="w3-container">
              <img src="./imagen/home.png" style="width:20%">
              <p>home<br><b>$24.99</b></p>
            </div>
            <div class="w3-container">
             <img src="./imagen/home.png" style="width:20%">
             <p>home<br><b>$24.99</b></p>
           </div>
         </div>
         <div class="w3-col l3 s6">
          <div class="w3-container">
            <img src="./imagen/home.png" style="width:20%">
            <p>home<br><b>$24.99</b></p>
          </div>
          <div class="w3-container">
            <img src="./imagen/home.png" style="width:20%">
            <p>home<br><b>$24.99</b></p>
          </div>
        </div>
        <div class="w3-col l3 s6">
          <div class="w3-container">
            <img src="./imagen/home.png" style="width:20%">
            <p>home<br><b>$24.99</b></p>
          </div>
          <div class="w3-container">
            <img src="./imagen/home.png" style="width:20%">
            <p>home<br><b>$24.99</b></p>
          </div>
        </div>
      </div> -->
    </div>


    <div class="tab-pane" id="2b">
     <!-- Product grid -->
     <div class="w3-row" >
      <br><br><br>
      <div class="w3-col l3 s6">
        <div class="w3-container">
          <img src="./imagen/home.png" style="width:80px">
          <p>home<br><b>$24.99</b></p>
        </div>
      </div>

      <div class="w3-col l3 s6">
        <div class="w3-container">
          <img src="./imagen/home.png" style="width:80px">
          <p>home<br><b>$24.99</b></p>
        </div>
      </div>

      <div class="w3-col l3 s6">
        <div class="w3-container">
          <img src="./imagen/home.png" style="width:80px">
          <p>home<br><b>$24.99</b></p>
        </div>
      </div>

      <div class="w3-col l3 s6">
        <div class="w3-container">
          <img src="./imagen/home.png" style="width:80px">
          <p>home<br><b>$24.99</b></p>
        </div>
      </div>
    </div>          
  </div>
  <div class="tab-pane" id="3b">
   <!-- Product grid -->
   <div class="w3-row" >
    <br><br><br>
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="./imagen/home.png" style="width:80px">
        <p>home<br><b>$24.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="./imagen/home.png" style="width:80px">
        <p>home<br><b>$24.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="./imagen/home.png" style="width:80px">
        <p>home<br><b>$24.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="./imagen/home.png" style="width:80px">
        <p>home<br><b>$24.99</b></p>
      </div>
    </div>
  </div>                   
</div>
<div class="tab-pane" id="4b">
 <!-- Product grid -->
 <div class="w3-row" >
  <br><br><br>
  <div class="w3-col l3 s6">
    <div class="w3-container">
      <img src="./imagen/home.png" style="width:80px">
      <p>home<br><b>$24.99</b></p>
    </div>
  </div>

  <div class="w3-col l3 s6">
    <div class="w3-container">
      <img src="./imagen/home.png" style="width:80px">
      <p>home<br><b>$24.99</b></p>
    </div>
  </div>

  <div class="w3-col l3 s6">
    <div class="w3-container">
      <img src="./imagen/home.png" style="width:80px">
      <p>home<br><b>$24.99</b></p>
    </div>
  </div>

  <div class="w3-col l3 s6">
    <div class="w3-container">
      <img src="./imagen/home.png" style="width:80px">
      <p>home<br><b>$24.99</b></p>
    </div>
  </div>
</div>                   
</div>
</div>
<!-- </div> -->
<!-- </div> --><!-- fin parte2 -->

</div><!-- fin capa 3-->



<!-- ini parte 3 -->

      <!-- <div id="tercera">
        <h2>Simulador</h2>
        <div class="w3-cell-row">
          <div class="w3-container w3-red w3-cell w3-cell-top">
           <p style="float: left">min 0</p>
           <p style="float: right">max 100</p>
           <input type="range" min="0" max="50" value="0" step="1" onchange="showValue(this.value,'range1')" />
           <span id="range1">0</span>

         </div>
         <div class="w3-container w3-green w3-cell w3-cell-middle">
          <p style="float: left">min 0</p>
          <p style="float: right">max 100</p>
          <input type="range" min="0" max="50" value="0" step="1" onchange="showValue(this.value,'range2')" />
          <span id="range2">0</span>
        </div>
        <div class="w3-container w3-blue w3-cell w3-cell-bottom">
          <p style="float: left">min 0</p>
          <p style="float: right">max 100</p>
          <input type="range" min="0" max="500.000" value="0" step="1" onchange="showValue(this.value,'range3')" />
          <span id="range3">0</span>
        </div>
      </div>
    </div> --><!-- fin parte 3 -->
  </BODY>


</div> <!--  fin capa2 -->

</div> <!-- fin capa1 -->



<div id="galeria" class="container">
  <h2>Image Gallery</h2>
  <p>The .thumbnail class can be used to display an image gallery.</p>
  <p>The .caption class adds proper padding and a dark grey color to text inside thumbnails.</p>
  <p>Click on the images to enlarge them.</p>
  <div class="row">
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="./imagen/imagen1.jpg" target="_blank">
          <img src="./imagen/imagen1.jpg" alt="Lights" style="width:100%">
          <div class="caption">
            <p>Lorem ipsum donec id elit non mi porta gravida at eget metus.</p>
          </div>
        </a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="./imagen/imagen1.jpg" target="_blank">
          <img src="./imagen/imagen1.jpg" alt="Nature" style="width:100%">
          <div class="caption">
            <p>Lorem ipsum donec id elit non mi porta gravida at eget metus.</p>
          </div>
        </a>
      </div>
    </div>
    <div class="col-md-4">
      <div class="thumbnail">
        <a href="./imagen/imagen1.jpg" target="_blank">
          <img src="./imagen/imagen1.jpg" alt="Fjords" style="width:100%">
          <div class="caption">
            <p>Lorem ipsum donec id elit non mi porta gravida at eget metus.</p>
          </div>
        </a>
      </div>
    </div>
  </div>
</div>




<!-- Footer -->
<footer class="w3-padding-64 w3-light-grey w3-small w3-center" id="footer">
  <div class="w3-row-padding">
   <!--  <div class="w3-col s4">
      <h4>联系方式</h4>
      <p>提问 Go ahead.</p>
      <form action="/action_page.php" target="_blank">
        <p><input class="w3-input w3-border" type="text" placeholder="姓名" name="Name" required></p>
        <p><input class="w3-input w3-border" type="text" placeholder="邮箱地址" name="Email" required></p>
        <p><input class="w3-input w3-border" type="text" placeholder="题目" name="Subject" required></p>
        <p><input class="w3-input w3-border" type="text" placeholder="内容" name="Message" required></p>
        <button type="submit" class="w3-button w3-block w3-black">发送</button>
      </form>
    </div> -->

    <div class="w3-col s4">
      <h4>信息</h4>
      <p><a href="#">关于我们</a></p>
      <p><a href="#">招聘</a></p>
      <p><a href="#">支持</a></p>
      <p><a href="#">找到店址</a></p>
      <p><a href="#">Shipment</a></p>
      <p><a href="#">付款</a></p>
      <p><a href="#">礼物卡</a></p>
      <p><a href="#">返回</a></p>
      <p><a href="#">帮助</a></p>
    </div>

    <div class="w3-col s4 w3-justify">
      <h4>店名</h4>
      <p><i class="fa fa-fw fa-map-marker"></i> 公司名称</p>
      <p><i class="fa fa-fw fa-phone"></i> 0044123123</p>
      <p><i class="fa fa-fw fa-envelope"></i> ex@mail.com</p>
      <h4>确认</h4>
      <p><i class="fa fa-fw fa-cc-amex"></i> Amex</p>
      <p><i class="fa fa-fw fa-credit-card"></i> 信用卡</p>
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


<script type="text/javascript">

</script>



</body>
</html>









