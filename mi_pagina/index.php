<!DOCTYPE html>
<html>
<title>Template</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
.w3-sidebar a {font-family: "Roboto", sans-serif}
body,h1,h2,h3,h4,h5,h6,.w3-wide {font-family: "Montserrat", sans-serif;}
</style>
<body class="w3-content" style="max-width:1200px">

<!-- Sidebar/menu -->
<nav class="w3-sidebar w3-bar-block w3-white w3-collapse w3-top" style="z-index:3;width:250px" id="mySidebar">
  <div class="w3-container w3-display-container w3-padding-16">
    <i onclick="w3_close()" class="fa fa-remove w3-hide-large w3-button w3-display-topright"></i>
    <h3 class="w3-wide"><b>LOGO</b></h3>
  </div>
  <div class="w3-padding-64 w3-large w3-text-grey" style="font-weight:bold">
    <a href="#" class="w3-bar-item w3-button">袜子</a>
    <a href="#" class="w3-bar-item w3-button">裙子</a>
    <a onclick="myAccFunc()" href="javascript:void(0)" class="w3-button w3-block w3-white w3-left-align" id="myBtn">
      牛仔系列 <i class="fa fa-caret-down"></i>
    </a>
    <div id="demoAcc" class="w3-bar-block w3-hide w3-padding-large w3-medium">
      <a href="#" class="w3-bar-item w3-button w3-light-grey"><i class="fa fa-caret-right w3-margin-right"></i>模版</a>
      <a href="#" class="w3-bar-item w3-button">休闲</a>
      <a href="#" class="w3-bar-item w3-button">越野</a>
      <a href="#" class="w3-bar-item w3-button">时尚</a>
    </div>
    <a href="#" class="w3-bar-item w3-button">夹克</a>
    <a href="#" class="w3-bar-item w3-button">线衫</a>
    <a href="#" class="w3-bar-item w3-button">内衣</a>
    <a href="#" class="w3-bar-item w3-button">鞋</a>
  </div>
  <a href="#footer" class="w3-bar-item w3-button w3-padding">联系方式</a> 
  <a href="javascript:void(0)" class="w3-bar-item w3-button w3-padding" onclick="document.getElementById('newsletter').style.display='block'">填写</a> 
  <a href="#footer"  class="w3-bar-item w3-button w3-padding">订购</a>
</nav>

<!-- Top menu on small screens -->
<header class="w3-bar w3-top w3-hide-large w3-black w3-xlarge">
  <div class="w3-bar-item w3-padding-24 w3-wide">LOGO</div>
  <a href="javascript:void(0)" class="w3-bar-item w3-button w3-padding-24 w3-right" onclick="w3_open()"><i class="fa fa-bars"></i></a>
</header>



<!-- Overlay effect when opening sidebar on small screens -->
<!-- <div class="w3-overlay w3-hide-large" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div> -->

<!-- !PAGE CONTENT! -->
<div>
  <center>
  <h3>Envio</h3>
<form action="mail.php" method="post">
    Correo Electronico:<input type="email" name="mail" /><br>
    Escribe un comentario:<br>
    <textarea name="com"></textarea><br>
    <input type="submit" name="enviar" value="Enviar Comentario">
  </form>
  </center>
</div>
<div class="w3-main" style="margin-left:250px">

<p>
  <form action="valida_foto.php" method="POST" enctype="multipart/form-data">
  <center><strong><h4>INSERTA RUTA DE FOTOS A LA BD</h1></strong></center>
  <center><table border= "1">
    <tr bgcolor = "skyblue">
       <td><strong>Nombre: </strong></td><td><input type="text" name="txtnom" value=""></td>
    </tr>
    
    <tr bgcolor = "skyblue">
       <td><strong>Foto: </strong></td><td><input type="file" name="foto" id="foto"></td>
    </tr>   

    <tr>
       <td colspan="2" align="center" bgcolor = "skyblue"><input type="submit" name="enviar" value="Enviar"></td>

    </tr> 

  </center> </table>
</p>


  <!-- Push down content on small screens -->
  <div class="w3-hide-large" style="margin-top:83px"></div>
  
  <!-- Top header -->
  <header class="w3-container w3-xlarge">
    <p class="w3-left">牛仔</p>
    <p class="w3-right">
      <i class="fa fa-shopping-cart w3-margin-right"></i>
      <i class="fa fa-search"></i>
    </p>
  </header>

  <!-- Image header -->
  <div class="w3-display-container w3-container">
    <img src="/w3images/mini.jpg" alt="Jeans" style="width:100%">
    <div class="w3-display-topleft w3-text-white" style="padding:24px 48px">
      <!-- <h1 class="w3-jumbo w3-hide-small">哈喽，小刘向你问好</h1> -->
      <!-- <h1 class="w3-hide-large w3-hide-medium">哈喽，小刘向你问好</h1> -->
      <h1 class="w3-hide-small">2017 新款上市</h1>
      <p><a href="#jeans" class="w3-button w3-black w3-padding-large w3-large">购物</a></p>
    </div>
  </div>

  <div class="w3-container " id="jeans">
    <!--w3-text-grey. w3-grayscale-->
    <p>8 件</p>
  </div>

  <!-- Product grid -->
  <div class="w3-row ">
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div>

<div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div>
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div>
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div>
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div><div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div><div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div>
    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/美女批发.jpeg" style="width:100%">
        <p>美女批发<br><b>$24.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/撩妹钻戒.jpeg" style="width:100%">
        <p>撩妹钻戒<br><b>$19.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <div class="w3-display-container">
          <img src="/w3images/国宝一只.jpg" style="width:100%">
          <span class="w3-tag w3-display-topleft">新款</span>
          <div class="w3-display-middle w3-display-hover">
            <button class="w3-button">立刻订阅 <i class="fa fa-shopping-cart"></i></button>
          </div>
        </div>
        <p>国宝<br><b>$19.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/哈士奇.jpg" style="width:100%">
        <p>特价哈士奇<br><b>$20.50</b></p>
      </div>
    </div>


  <div class="w3-col l3 s6">
      <div class="w3-container">
        <div class="w3-display-container">
          <img src="/w3images/国宝一只.jpg" style="width:100%">
          <span class="w3-tag w3-display-topleft">新款</span>
          <div class="w3-display-middle w3-display-hover">
            <button class="w3-button">立刻订阅 <i class="fa fa-shopping-cart"></i></button>
          </div>
        </div>
        <p>国宝<br><b>$19.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/哈士奇.jpg" style="width:100%">
        <p>特价哈士奇<br><b>$20.50</b></p>
      </div>
    </div>



    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/capitan .jpeg" style="width:100%">
        <p>美国队长<br><b>$20.50</b></p>
      </div>
      <div class="w3-container">
        <div class="w3-display-container">
          <img src="/w3images/capitan .jpeg" style="width:100%">
          <span class="w3-tag w3-display-topleft">限量版</span>
          <div class="w3-display-middle w3-display-hover">
            <button class="w3-button">立即订阅 <i class="fa fa-shopping-cart"></i></button>
          </div>
        </div>
        <p>宝石<br><b class="w3-text-red">$14.99</b></p>
      </div>
    </div>

    <div class="w3-col l3 s6">
      <div class="w3-container">
        <img src="/w3images/Rio-2-Official-Trailer-3-40.jpg" style="width:100%">
        <p>动画<br><b>$14.99</b></p>
      </div>
      <div class="w3-container">
        <img src="/w3images/Soñar-con-Diamantes.gif" style="width:100%">
        <p>钻石<br><b>$24.99</b></p>
      </div>
    </div>
  </div>

  <!-- Subscribe section -->
  <div class="w3-container w3-black w3-padding-32">
    <h1>申请</h1>
    <p>会员待遇，不一样的体验</p>
    <p><input class="w3-input w3-border" type="text" placeholder="输入邮箱地址" style="width:100%"></p>
    <button type="button" class="w3-button w3-red w3-margin-bottom">申请</button>
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

  <div class="w3-black w3-center w3-padding-24">支持 <a href="https://www.google.com" title="W3.CSS" target="_blank" class="w3-hover-opacity">w3.css</a></div>

  <!-- End page content -->
</div>

<!-- Newsletter Modal -->
<div id="newsletter" class="w3-modal">
  <div class="w3-modal-content w3-animate-zoom" style="padding:32px">
    <div class="w3-container w3-white w3-center">
      <i onclick="document.getElementById('newsletter').style.display='none'" class="fa fa-remove w3-right w3-button w3-transparent w3-xxlarge"></i>
      <h2 class="w3-wide">新邮件</h2>
      <p>我们将第一时间提供您上市新款</p>
      <p><input class="w3-input w3-border" type="text" placeholder="Enter e-mail"></p>
      <button type="button" class="w3-button w3-padding-large w3-red w3-margin-bottom" onclick="document.getElementById('newsletter').style.display='none'">确认</button>
    </div>
  </div>
</div>

<script>
// Accordion 
function myAccFunc() {
    var x = document.getElementById("demoAcc");
    if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
    } else {
        x.className = x.className.replace(" w3-show", "");
    }
}

// Click on the "Jeans" link on page load to open the accordion for demo purposes
document.getElementById("myBtn").click();


// Script to open and close sidebar
function w3_open() {
    document.getElementById("mySidebar").style.display = "block";
    document.getElementById("myOverlay").style.display = "block";
}
 
function w3_close() {
    document.getElementById("mySidebar").style.display = "none";
    document.getElementById("myOverlay").style.display = "none";
}
</script>

</body>
</html>
