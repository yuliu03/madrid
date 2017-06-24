<?php
echo "destino es $destino";
	$dbuser="root";
	$dbpass="";
	$dbname="prueba";
	$chandle = mysql_connect("localhost", $dbuser, $dbpass) or die("Error conectando a la BBDD");
	echo "Conectado correctamente";

    mysql_select_db($dbname, $chandle) or die ($dbname . " Base de datos no encontrada." . $dbuser);
    echo "Base de datos " . $database . " seleccionada";
    
	// mysql_connect("localhost","root","");
	// mysql_select_db("subir_foto")
?>