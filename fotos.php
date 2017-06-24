<?php
$mysqli = new mysqli("localhost", "root", "", "prueba");
  /* comprobar la conexión */
if ($mysqli->connect_errno) {
    printf("Falló la conexión: %s\n", $mysqli->connect_error);
    exit();
}


/* Crear una tabla que no devuelve un conjunto de resultados */
if ($mysqli->query("CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255) 
);") === TRUE) {
    printf("Se creó con éxtio la tabla Persons.\n");
}
//borrar tabla
// if ($mysqli->query("DROP TABLE Persons;") === TRUE) {
//     printf("Se ha borrado con éxtio la tabla Persons.\n");
// }

//inisertar
if ($mysqli->query("INSERT INTO Persons (PersonID, LastName,FirstName, Address, City)
VALUES ('12345', 'Tom B. Erichsen', 'Skagen 21', 'Stavanger','Norway');") === TRUE) {
    printf("Se ha insertado valores con éxtio la tabla Persons.\n");
}


/* Consultas de selección que devuelven un conjunto de resultados */
if ($resultado = $mysqli->query("SELECT PersonID FROM City ")) {
    printf("La selección devolvió %d filas.\n", $resultado->num_rows);

    /* liberar el conjunto de resultados */
    $resultado->close();
} 

//borrar valor
//  if ($mysqli->query("DELETE FROM Persons
// WHERE PersonID='12345';") === TRUE) {
//      printf("Se ha borrado valores con éxtio la tabla Persons.\n");
//  }



  


// $conexion = mysqli_connect('localhost', 'root', '', 'prueba');
// $subconsulta="SELECT * FROM fotos";

//     $result = mysqli_query($conexion, $subconsulta);
    
//     while ($columnas = mysqli_fetch_assoc($filas) ){
//             echo '<div>';
//             echo "<p>$columnas[nombre]</p>";
//             echo "<img src='fotos/$columnas[archivo]' />";
//             echo '</div>';
//         }

// if ($resultado = $mysqli->query($consulta)) {

//     while ($fila = $resultado->fetch_assoc()) {
//         printf ("%s (%s)\n", $fila["Name"], $fila["CountryCode"]);
//     }

//     $resultado->free();
// }
?>




