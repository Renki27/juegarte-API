<?php


require 'DB.php';

if ($_GET["request"] == "loadScrQue") {


  //  echo "GET";

    $questionsPayload = loadTriviaQuestions($database);

    if ($questionsPayload) {
        $length = count($questionsPayload);
        $triviaQuestions = [];
        if($length > 0) {
            for ($i = 0; $i < $length; $i++) {

            
                $questions =
                    array(
                        "question_text" => $questionsPayload[$i]["QUESTION_TEXT"],
                        "question_info" => $questionsPayload[$i]["QUESTION_INFORMATION"],
                        "question_img" => $questionsPayload[$i]["QUESTION_IMAGE"],
                        "option1" => $questionsPayload[$i]["T1_OPTION_Q_1"],
                        "option2" => $questionsPayload[$i]["T1_OPTION_Q_2"],
                        "option3" => $questionsPayload[$i]["T1_OPTION_Q_3"],
                        "option4" => $questionsPayload[$i]["T1_OPTION_Q_4"],
                        "answer" => $questionsPayload[$i]["T1_ANSWER"]
                    );
                    array_push($triviaQuestions, $questions); 
            }

        }
  


        $response['status'] = "Success";
        $response['message'] = "Questions loaded loaded!";
        $response['scratchQuestions'] = $triviaQuestions;
    } else {
        $response['status'] = "Error";
        $response['message'] = "Questions not found!"; 
    }







  //  header("Content-type: application/json");
    echo json_encode($response);
}



function loadTriviaQuestions($database)
{
    $sql = 'CALL `SELECT_TRIVIA_QUESTIONS`()';
    $sth = $database->pdo->prepare($sql);
    $sth->execute();
    return $sth->fetchAll(PDO::FETCH_SERIALIZE);
}