<?php
	$servername = "localhost";
	$username = "root";
	$password = "";
	$dbname = "fotos";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT id, name ,OrderDate,tipo FROM Fotos";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Name: " . $row["name"]. "tiempo " . $row["OrderDate"]." tipo es ". $row["tipo"]."<br>";
        $fs=$row["name"];
        echo "<p>show is <img src=".$fs."></p>";
    }
} else {
    echo "0 results";
}
$conn->close();
?>