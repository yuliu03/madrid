<?php
	require('conexion.php') ;
	$nom=$_REQUEST['txtnom'];
	$foto1=$_FILES['foto']['name'];
	$ruta=$_FILES['foto']['tmp_name'];
	$destino= 'w3images/';
	$exito=$_FILES['foto']['error'];

	//copy($ruta,$destino);
	 

	 if(is_uploaded_file($_FILES["foto"]["tmp_name"])){
	 	move_uploaded_file('./w3images/mini.jpg','./fotos/');
	 	 mysql_query("insert into fotos (nombre,foto) values('$nom','$exito')");
	//mysql_query("insert into prueba (nombre) values('$nom')");
	 }
	

	header("Location: index.php");
?>

