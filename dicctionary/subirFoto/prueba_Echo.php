
<?php
echo "Hola mundo <br>";

$x="./fotos/training_set.png";
echo "<p>
<img src=".$x.">
Esto abarca
multiple líneas. Los saltos de línea también
se mostrarán</p>";

echo "Esto abarca.múltiples líneas. Los saltos de línea también.se mostrarán.";

echo "Para escapar caracteres se hace \"así\".<br>";

// Se pueden usar variables dentro de una sentencia echo
$foo = "foobar";
$bar = "barbaz";

echo "<br>foo es $foo<br>"; // foo es foobar

// También se pueden usar arrays
$baz = array("valor" => "foo");

echo "Esto es {$baz['valor']} !<br>"; // Esto es foo !

// Si se utilizan comillas simples, se mostrará el nombre de la variable, no su valor
echo 'foo es $foo <br>'; // foo es $foo

// Si no usan otros caracteres, se puede utilizar echo para mostrar el valor de las variables.
echo $foo." hello <br>";          // foobar
echo $foo,$bar."<br>";     // foobarbarbaz

// Las cadenas pueden ser pasadas individualmente como varios argumentos o
// concatenadas como un único argumento
echo 'Esta ', 'cadena ', 'está ', 'hecha ', 'con múltiple parámetros.', chr(10);
echo 'Esta ' . 'cadena ' . 'está ' . 'hecha ' . 'con concatenación.' . "\n";




?>
