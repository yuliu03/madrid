<?php
// define variables and set to empty values
$name = $email = $gender = $planta = $puerta= $precio=$Codigo_Postal= $otro2=$otro1=$zona="";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $name = test_input($_POST["name"]);
  $email = test_input($_POST["email"]);
  $planta = test_input($_POST["planta"]);
  $puerta = test_input($_POST["puerta"]);
  $gender = test_input($_POST["gender"]);

  $precio = test_input($_POST["precio"]);
  $Codigo_Postal = test_input($_POST["Codigo_Postal"]);
  $otro2 = test_input($_POST["otro2"]);
   $otro1 = test_input($_POST["otro1"]);
    $zona = test_input($_POST["zona"]);
}

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}


$servername = "localhost";
$username = "root";
$password = "";
$dbname = "pisos";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$n='liu';
$sql = "INSERT INTO casa (planta, puerta, precio,codigo_postal,calle,zona,otro1,otro2)
VALUES ('6','B','9000000','12345', 'acero', 'aviles','','')";


if ($conn->query($sql) === TRUE) {
    echo "New record created successfully<br>";
	$consulta="SELECT id FROM casa WHERE planta='6'";
	$result = $conn->query($consulta);
	if ($result->num_rows > 0){
		while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. "<br>";
        $nom=$row["id"]."_tabla";
    	}
    	echo $nom;
	}

} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();



/*echo "<h2>Your Input:</h2>";
echo $name;
echo "<br>";
echo $email;
echo "<br>";
echo $planta;
echo "<br>";
echo $puerta;
echo "<br>";
echo $gender;
echo "<br>";
echo $precio;
echo "<br>";
echo $Codigo_Postal;
echo "<br>";
echo $otro2;
echo "<br>";
echo $otro1;
echo "<br>";
echo $zona;*/
?>