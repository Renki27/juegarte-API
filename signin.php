<?php


require 'DB.php';
//require 'Cors.config.php';


//$method = $_SERVER['REQUEST_METHOD'];
//var_dump($method);


//para ver que tipo de request está reciviendo

//echo "<script>console.log('$request' );</script>";
//echo $username;
//echo "<script>console.log('$username' );</script>";
if ($_POST) {

    $username = $_POST['username'];
    $password = $_POST['password'];
    $userExist = verifyByUsername($database, $username);

    if ($userExist == 1) {
        $user = getUser($database, $username, $password);

        //var_dump($user);
        if ($user != null) {
            $hash = $user[0]["PASSWORD"];
            if (password_verify($_POST["password"], $hash)) {
                $response = array();
                $response['userData'] = array();

                $index['username'] = $user[0]["USERNAME"];
                $index['email'] = $user[0]["EMAIL"];
                $index['points'] = $user[0]["POINTS"];
                $index['image'] = $user[0]["IMAGE"];

                
                array_push($response['userData'], $index);

                /*
                $userData =
                    array(
                        "username" => $user[0]["USERNAME"],
                        "email" => $user[0]["EMAIL"],
                        "points" => $user[0]["POINTS"],
                        "image" => $user[0]["IMAGE"]
                    );*/
                //  $json = json_encode($userData);
                //  echo ($json);

                //    header("Content-type: application/json");
                //  echo json_encode($userData);
                $response['status'] = "Success";
                $response['message'] = "Logged in!";
               // $response['userData'] = $userData;
         
            } else {
                //   echo  "wrong user or password";
                $response['status'] = "Error";
                $response['message'] = "Wrong user or password";
            }
        } else {
            // echo "Invalid user data!";
            $response['status'] = "Error";
            $response['message'] = "Invalid user data!";
        }
    } else {
        $response['status'] = "Error";
        $response['message'] = "Used not registered";
    }

 //   header("Content-type: application/json");
    echo json_encode($response);
}


function verifyByUsername($database, $username)
{
    $sql = 'CALL VERIFY_USER_EXISTS_USERNAME (?)';
    $sth = $database->pdo->prepare($sql);

    $sth->bindParam(1, $username, PDO::PARAM_STR, 25);
    $sth->execute();
    $exist = $sth->fetchAll(PDO::FETCH_ORI_FIRST);
    return $exist[0]["COUNT(*)"];
}





function getUser($database, $username)
{
    $sql = 'CALL SELECT_USER_BY_USERNAME (?)';
    $sth = $database->pdo->prepare($sql);

    $sth->bindParam(1, $username, PDO::PARAM_STR, 25);
    $sth->execute();
    $userdata = $sth->fetchAll(PDO::FETCH_ORI_FIRST);
    return $userdata;
}
