<HTML>
	<HEAD>
		<TITLE>ejemplo hola mundo</TITLE>
	</HEAD>
	<BODY><div >

	<?php
	session_start();
	if(!isset($_SESSION["usuario"])){
		echo 'Hola Cliente';
	}else{
		header("Location:login.php");
	}
	?>
	</BODY>
</HTML>