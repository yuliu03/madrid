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

 $n='liu';
 $t='';
 $sql = "INSERT INTO casa (planta, puerta, precio,codigo_postal,calle,zona,otro1)
 VALUES ('7','B','1000000','12345','eduardo barreiros','moncloa',"."'".$n."'".")";

 if ($conn->query($sql) === TRUE) {
 	echo "New record created successfully";
    /////
 	$sql = "SELECT id FROM casa WHERE planta=7";
 	$result = $conn->query($sql);

 	if ($result->num_rows > 0) {
    // output data of each row
 		$row = $result->fetch_assoc();
 		echo "id: " . $row["id"];
 		$t= $row["id"];
 		echo "valor t es $t";

        //crear talba asociada
 		$nom_tabla="tabla".$t;
 		echo "Table Persons created successfully";
 		$sql = "CREATE TABLE ".$nom_tabla."(
 		fotoId int(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 		ruta VARCHAR(100) NOT NULL,
 		id_casa INT(8) UNSIGNED,
 		reg_date TIMESTAMP,
 		FOREIGN KEY (id_casa) REFERENCES casa(id)
 		)";

 		if ($conn->query($sql) === TRUE) {
 			echo "Table  created successfully";
 		} else {
 			echo "Error creating table de foto: " . $conn->error;
 		}

 	} else {
 		echo "0 results, no es posible empezar crear nueva tabla de foto";
 	}

    ////

 } else {
 	echo "Error: " . $sql . "<br>" . $conn->error;
 }

 $conn->close();
 ?> 