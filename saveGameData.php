<?php
require 'DB.php';

if ($_POST) {
 

        if (($_POST['idGame'] != null) && ($_POST['username'] != null) && ($_POST['obtainedPoints'] != null)) {
            
            $idGame = $_POST['idGame'];
            $username = $_POST['username'];
            $obtainedPoints = $_POST['obtainedPoints'];
           // var_dump($idGame, $username, $obtainedPoints);
            saveGameData($database, $idGame, $username, $obtainedPoints);
            $response['status'] = "Success";
            $response['message'] = "Game data saved";
        } else {
            $response['status'] = "Error";
            $response['message'] = "An error has occurred!";
        }
    }
  // header("Content-type: application/json");
    echo json_encode($response);




$database = null;


function saveGameData($database, $idGame, $username, $obtainedPoints)
{
    $sql = 'CALL INSERT_ACCOUNT_GAME(?,?,?)';
    $sth = $database->pdo->prepare($sql);

    $sth->bindParam(1, $idGame, PDO::PARAM_INT, 3);
    $sth->bindParam(2, $username, PDO::PARAM_STR, 25);
    $sth->bindParam(3, $obtainedPoints, PDO::PARAM_INT, 5);
 


    $sth->execute();
}