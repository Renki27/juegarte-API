<?php
require 'DB.php';

if ($_POST) {
 

        if (($_POST['username'] != null) && ($_POST['points'] != null)) {
            
            $username = $_POST['username'];
            $points = $_POST['points'];
           // var_dump($idGame, $username, $obtainedPoints);
            updatePoints($database, $username, $points);
            $response['status'] = "Success";
            $response['message'] = "Account updated!";
        } else {
            $response['status'] = "Error";
            $response['message'] = "An error has occurred!";
        }
    }
  // header("Content-type: application/json");
    echo json_encode($response);




$database = null;


function updatePoints($database, $username, $points)
{
    $sql = 'CALL UPDATE_ACCOUNT_POINTS(?,?)';
    $sth = $database->pdo->prepare($sql);

    $sth->bindParam(1, $username, PDO::PARAM_STR, 25);
    $sth->bindParam(2, $points, PDO::PARAM_INT, 5);

    $sth->execute();
}