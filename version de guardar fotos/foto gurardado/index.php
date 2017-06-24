<HTML>
<HEAD>
<TITLE>ejemplo hola mundo</TITLE>
</HEAD>
<BODY>
	<?php
$conexion = mysqli_connect('localhost', 'root', '', 'prueba');
?>

<form class="form" method="post" enctype="multipart/form-data" action="guardar_foto.php">
        <div>
            <h3>Subir Foto</h3>
            <input type="text" placeholder="Titulo" name="titulo" /><br>
            <input type="file" name="archivo" />
        </div>
         <br>
        <input type="submit" name="Almacenar" value="Almacenar" />
</form>
</BODY>
</HTML>