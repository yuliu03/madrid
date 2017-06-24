<?php
	require('conexion.php') ;
	$nom=$_REQUEST['txtnom'];
	$foto1=$_FILES['foto']['name'];
	$ruta=$_FILES['foto']['tmp_name'];
	$destino= $_SERVER['DOCUMENT_ROOT'].'/madrid/fotos/';
	//copy($ruta,$destino);
	///Applications/XAMPP/xamppfiles/temp/mini.jpg

	 if(is_uploaded_file($_FILES['foto']['tmp_name'])){
	 	 move_uploaded_file('/Applications/XAMPP/xamppfiles/temp/mini.jpg',"/Applications/XAMPP/xamppfiles/temp/nuevaImagen.jpg");
	 	 mysql_query("insert into fotos (nombre,foto) values('$nom','$ruta')");
	//mysql_query("insert into prueba (nombre) values('$nom')");
	 }
	

	header("Location: index.php");
?>

