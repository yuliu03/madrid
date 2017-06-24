<?php
// GrabFile.php: Takes the details
// of the new file posted as part
// of the form and adds it to the
// myBlobs table of our myFiles DB.
$strDesc = $_POST['strDesc']; 
$fileUpload = $_FILES['fileUpload']; 
$fileUpload_name = $_FILES['fileUpload']['name']; 
$fileUpload_type = $_FILES['fileUpload']['type']; 
$fileUpload_size = $_FILES['fileUpload']['size'];  
// Make sure both a description and
// file have been entered
if( $fileUpload == "none"){
	die("You must enter both a description and file, 2");;
}
if(empty($strDesc)){
	die("You must enter both a description and file, 1");;
}



$dbServer = "localhost";
$dbDatabase = "myFiles";
$dbUser = "root";
$dbPass = "";

$fileHandle = fopen($fileUpload['tmp_name'], "r");
$fileContent = fread($fileHandle, $fileUpload_size);
$fileContent = addslashes($fileContent);


//die("$fileContent");
$sConn = mysql_connect($dbServer, $dbUser, $dbPass)or die("Couldn't connect to database server");
$dConn = mysql_select_db($dbDatabase, $sConn)or die("Couldn't connect to database $dbDatabase");

//$dbQuery = "INSERT INTO myBlobs VALUES ";
//$dbQuery .= "(0, '$strDesc', '$fileContent', '$fileUpload_type')";

mysql_query("insert into myBlobs (blobId,blobTitle,blobData,blobType) values(0, '$strDesc', '$fileContent', '$fileUpload_type')");



echo "<h1>File Uploaded</h1>";
echo "The details of the uploaded file are shown below:<br><br>";
echo "<b>File name:</b> $fileUpload_name <br>";
echo "<b>File type:</b> $fileUpload_type <br>";
echo "<b>File size:</b> $fileUpload_size <br>";
echo "<b>Uploaded to:</b> $fileUpload <br><br>";
echo "<a href='index.php'>Add Another File</a>";



########## imagen_mostrar.php ##########

# debe recibir el id de la imagen a mostrar

# http://www.lawebdelprogramador.com


?>













