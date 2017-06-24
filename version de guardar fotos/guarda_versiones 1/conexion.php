<?php
echo "destino es $destino";
	$dbuser="u405191082_liuyu";
	$dbpass="universidad1024";
	$dbname="u405191082_try";
	$chandle = mysql_connect("mysql.hostinger.es", $dbuser, $dbpass) or die("Error conectando a la BBDD");
	echo "Conectado correctamente";

    mysql_select_db($dbname, $chandle) or die ($dbname . " Base de datos no encontrada." . $dbuser);
    echo "Base de datos " . $database . " seleccionada";
    
	// mysql_connect("localhost","root","");
	// mysql_select_db("subir_foto")
?>