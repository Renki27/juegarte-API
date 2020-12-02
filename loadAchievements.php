<?php


require 'DB.php';

if ($_GET["request"] == "list") {


  //  echo "GET";

    $achievementsPayload = loadAchievements($database);

    if ($achievementsPayload) {
        $length = count($achievementsPayload);
        $achievements = [];
        for ($i = 0; $i < $length; $i++) {

            
            $achievementList =
                array(
                    "id" => $achievementsPayload[$i]["ID_ACHIEVEMENT"],
                    "title" => $achievementsPayload[$i]["ACHIEVEMENT_TITLE"],
                    "description" => $achievementsPayload[$i]["ACHIEVEMENT_DESCRIPTION"],
                    "completedStep" => $achievementsPayload[$i]["A_COMPLETED_STEP"]
                );
                array_push($achievements, $achievementList); 
        }


        $response['status'] = "Success";
        $response['message'] = "Achievements loaded!";
        $response['achievementList'] = $achievements;
    } else {
        $response['status'] = "Error";
        $response['message'] = "Achievements not found!"; 
    }







    //  header("Content-type: application/json");
      echo json_encode($response);
  }
  
  
  
  function loadAchievements($database)
  {
      $sql = 'CALL `SELECT_ACHIEVEMENTS`()';
      $sth = $database->pdo->prepare($sql);
      $sth->execute();
      return $sth->fetchAll(PDO::FETCH_SERIALIZE);
  }
  