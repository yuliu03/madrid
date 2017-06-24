<?php
$conexion = mysqli_connect('localhost', 'root', '', 'prueba');

     $subconsulta="SELECT * FROM fotos";

    $filas = mysqli_query($conexion, $subconsulta);
    while ($columnas = mysqli_fetch_assoc($filas) ){
            echo '<div>';
            echo "<p>$columnas[nombre]</p>";
            echo "<img src='../../fotos/$columnas[archivo]' />";
            echo '</div>';
        }

?>