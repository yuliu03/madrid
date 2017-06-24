<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javaScript">
	    // creamos nuestra PHP variable.
		<?php $phpvar    = "este es mi contenido en php un string.." ?>

		// y la metemos ahora en una variable Javascript.
        var jsvar  = '<?php echo $phpvar; ?>';

		// creemos un array de php y pasemos el contenido en una variable javascript.
		<?php $phparray  = array('un string', 1, 0.358); ?>

		// creamos ahora una array en javascript.
		var jsarray      = [];

		// pasemos nuestro array de php a nuestra array de javascript.
		<?php
		    for($i=0; $i < count($phparray); $i++ ){
		        echo 'jsarray['.$i.'] = "'.$phparray[$i].'";';
		    }
		?>

		window.onload = function(){
			alert(jsvar);
			alert(jsarray);
		}
	</script>
</head>
<body>
</body>
</html>