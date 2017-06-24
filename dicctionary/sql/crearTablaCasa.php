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

// sql to create table
$sql = "CREATE TABLE casa (
 id INT(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 planta int(3),
 puerta int(3),
 precio int(8),
 codigo_postal int(8),
 calle VARCHAR(100),
 zona VARCHAR(10),
 otro1 VARCHAR(100),
 otro2 VARCHAR(100),
 reg_date TIMESTAMP
 )";

 if ($conn->query($sql) === TRUE) {
 	echo "Table casa created successfully";
 } else {
 	echo "Error creating table: " . $conn->error;
 }

 $conn->close();
 ?> 

