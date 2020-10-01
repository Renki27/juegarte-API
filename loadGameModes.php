<?php


require 'DB.php';

if ($_GET["request"] == "loadGameModes") {


  //  echo "GET";

    $gamesPayload = loadGames($database);

    if ($gamesPayload) {
        $length = count($gamesPayload);
        $games = [];
        for ($i = 0; $i < $length; $i++) {

            
            $gameModes =
                array(
                    "id_game" => $gamesPayload[$i]["ID_GAME"],
                    "game_mode" => $gamesPayload[$i]["GAME_MODE_NAME"],
                    "instructions" => $gamesPayload[$i]["GAME_INSTRUCTIONS"],
                    "question_timer_seconds" => $gamesPayload[$i]["QUESTION_TIME_S"]
                );
                array_push($games, $gameModes); 
        }


        $response['status'] = "Success";
        $response['message'] = "Game modes loaded!";
        $response['gameModes'] = $games;
    } else {
        $response['status'] = "Error";
        $response['message'] = "Game modes not found!"; 
    }







  //  header("Content-type: application/json");
    echo json_encode($response);
}



function loadGames($database)
{
    $sql = 'CALL `SELECT_GAME_MODES`()';
    $sth = $database->pdo->prepare($sql);
    $sth->execute();
    return $sth->fetchAll(PDO::FETCH_SERIALIZE);
}


/*
    if ($gamesPayload) {
        $length = count($gamesPayload);
        $games = [];
        for ($i = 0; $i < $length; $i++) {
            $response = array();
            $response['gameModes'] = array();



            
            $gameModes =
                array(
                    "id_game" => $gamesPayload[$i]["ID_GAME"],
                    "game_mode" => $gamesPayload[$i]["GAME_MODE_NAME"],
                    "instructions" => $gamesPayload[$i]["GAME_INSTRUCTIONS"],
                    "question_timer_seconds" => $gamesPayload[$i]["QUESTION_TIME_S"]
                );
                array_push($games, $gameModes); 
                
        }


        $response['status'] = "Success";
        $response['message'] = "Game modes loaded!";
        array_push($response['gameModes'], $games);
    //    $response['gameModes'] = $games;

*/