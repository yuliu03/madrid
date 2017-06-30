<?php
	$destino=$_POST['mail'];
	$asunto="comentario";
	$comentario="
		Email:$_POST[mail]
		Comentario:$_POST[com]
	";
$headers = 'From: '.$destino."\r\n".
'Reply-To:'.$destino."\r\n".
'X-Mailer: PHP/'.phpversion();
mail($destino,$asunto,$comentario,$headers);

echo "Mensaje enviado";
?>