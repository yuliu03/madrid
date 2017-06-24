<?php
$conexion = mysqli_connect('localhost', 'root', '', 'prueba');

$titulo = $_POST['titulo'];
    $nombre_file = mktime() .'.jpg';
    $posicion = 0;
//"insert into fotos (nombre,foto) values('$nom','$exito')"
   // $consulta = "INSERT INTO fotos SET nombre='$titulo',archivo='$nombre_file'";
    $consulta = "INSERT INTO fotos (nombre,foto) values('$titulo','$nombre_file')";
    mysqli_query($conexion, $consulta);

        $origen = $_FILES['archivo']['tmp_name'];
        $destino = "fotos/$nombre_file";
      
        move_uploaded_file ($origen, $destino);

        header("Location: fotos.php");    

?>