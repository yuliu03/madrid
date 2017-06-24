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


$n="'".'liu'."'";
$n="'".'yu'."'";
$n="'".'yuliu03@yucm.es'."'";
$sql = "INSERT INTO MyGuests (firstname,lastname,email)
VALUES ('yu','liu',"."$n".")";

if ($conn->query($sql) === TRUE) {
    echo "New record created successfully";  

} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?> 