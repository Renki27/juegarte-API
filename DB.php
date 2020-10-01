<?php

require 'Medoo.php';
use Medoo\Medoo;

$database = new Medoo([
    'database_type' => 'mysql',
    'database_name' => 'juegarte_db',
    'server' => 'localhost',
    'username' => 'root',
    'password' => ''
]);
/*
$conn = $database->info()['dsn'];

if($conn) {
    echo "conection success";
} else {
    echo "connection failed";
}*/
?>