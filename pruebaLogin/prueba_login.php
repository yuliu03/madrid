<HTML>
	<HEAD>
		<TITLE>ejemplo hola mundo</TITLE>
	</HEAD>
	<BODY><div >

	<?php
	$login=htmlentities(addslashes($_POST["password"]));
	if($login==123)	{
		//echo 'adelante';
		 session_start();
		 $_SESSION["usuario"]=$_POST["password"];
		 echo $_SESSION["usuario"];
		//header('location:nueva.php');
	}else {
		header('location:login.php');
	}	
	
	?>
	</BODY>
</HTML>