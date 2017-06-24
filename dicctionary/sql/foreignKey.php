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
 $sql2 = "CREATE TABLE Persons (
 PersonID int(8) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 firstname VARCHAR(30) NOT NULL,
 lastname VARCHAR(30) NOT NULL,
 email VARCHAR(50),
 reg_date TIMESTAMP
 )";

 if ($conn->query($sql2) === TRUE) {
 	echo "Table Persons created successfully";

    // sql to create table
 	$sql = "CREATE TABLE Orders (
 	OrderID int(4) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 	OrderNumber int NOT NULL,
 	PersonID int(8) UNSIGNED ,
 	FOREIGN KEY (PersonID) REFERENCES Persons(PersonID)
 	)";

 	if ($conn->query($sql) === TRUE) {
 		echo "Table Orders created successfully";
 	} else {
 		echo "Error creating table: " . $conn->error;
 	}

 } else {
 	echo "Error creating table: " . $conn->error;
 }




 $conn->close();
 ?> 