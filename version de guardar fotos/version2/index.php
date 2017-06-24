<!DOCTYPE html>
<html>
<title>Template</title>
<meta charset="UTF-8">

<body class="w3-content" style="max-width:1200px">

<!-- Sidebar/menu -->




<!-- Overlay effect when opening sidebar on small screens -->
<!-- <div class="w3-overlay w3-hide-large" onclick="w3_close()" style="cursor:pointer" title="close side menu" id="myOverlay"></div> -->

<!-- !PAGE CONTENT! -->
<div class="w3-main" style="margin-left:250px">

<p>
  <form action="valida_foto.php" method="POST" enctype="multipart/form-data">
  <center><strong><h4>INSERTA RUTA DE FOTOS A LA BD</h1></strong></center>
  <center><table border= "1">
    <tr bgcolor = "skyblue">
       <td><strong>Nombre: </strong></td><td><input type="text" name="txtnom" value=""></td>
    </tr>
    
    <tr bgcolor = "skyblue">
       <td><strong>Foto: </strong></td><td><input type="file" name="foto" ></td>
    </tr>   

    <tr>
       <td colspan="2" align="center" bgcolor = "skyblue"><input type="submit" name="enviar" value="Enviar"></td>

    </tr> 

  </center> </table>
</p>


</body>
</html>
