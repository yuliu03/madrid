<!DOCTYPE html>
<html>
<link href="estilo.css" rel="stylesheet" type="text/css">

<head>
	<title></title>
</head>
<body>
<script type="text/javaScript">
		// creamos ahora una array en javascript.
		var dato      = [];
		var datos	  = [];

	<?php 

		$servername = "localhost";
		$username = "root";
		$password = "";
		$dbname = "myDB";

		// Create connection
		$conn = new mysqli($servername, $username, $password, $dbname);
		// Check connection
		if ($conn->connect_error) {
		    die("Connection failed: " . $conn->connect_error);
		}

		$sql = "SELECT id, firstname, lastname ,email FROM MyGuests";
		$result = $conn->query($sql);

		if ($result->num_rows > 0) {
		    // output data of each row
		    while($row = $result->fetch_assoc()) {
		        echo 'dato.push("'.$row["id"].'");';
		        echo 'dato.push("'.$row["firstname"].'");';
		        echo 'dato.push("'.$row["lastname"].'");';
		        echo 'dato.push("'.$row["email"].'");';
		        echo 'datos.push(dato);';
		    }
		} else {
		    echo "0 results";
		}
		$conn->close();

	?>

	
</script>

	<div id="contenedor">
	<div id="cabecera">
	cabecera
	</div>
	
	<div id="menu">
		menu
	</div>
	
	<div id="contenido">
		 
    </div>
	
	</div>
	
	<div id="pie">
	pie
	</div>
	</div>
</body>

<script type="text/javascript">
//mostrar los datos
	//document.getElementById("menu").innerHTML = datos;
	var hola="nuevo";
	var id="id = 'panel'";
	document.getElementById("contenido").innerHTML ="<div "+id+">"+ " <div>"+"Panel Heading"+"</div><div>Panel Content"+hola+"</div><div>Panel Footer</div>" ;
	document.getElementById("contenido").innerHTML +="<div "+id+">"+ " <div>"+"Panel Heading"+"</div><div>Panel Content"+hola+"</div><div>Panel Footer</div>" ;
</script>


</html>


 


