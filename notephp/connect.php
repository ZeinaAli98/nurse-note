<?php
$dsn = "mysql:host=localhost;dbname=notesapp";
$user = "root";
$password = "";
$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES UTF8"
);

try {
    $connect = new PDO($dsn, $user, $password, $options);
    $connect->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    include "functions.php";
} catch (PDOException $e) {
    echo $e->getMessage();
}
?>