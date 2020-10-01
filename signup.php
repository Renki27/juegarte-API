<?php
/*
if ($_SERVER['REQUEST_METHOD'] =='POST'){

    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];

    $password = password_hash($password, PASSWORD_DEFAULT);

    require_once 'connect.php';

    createAccount($conn, $username, $password, $email);


}


//CREATE ACCOUNT SP call
function createAccount($conn, $username, $password, $email)
{
    $sql = 'CALL CREATE_ACCOUNT (?,?,?)';
    $sth = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($sth,"sis",$username, $password, $email);
    mysqli_stmt_execute($sth);
    mysqli_stmt_close($sth);

    $sql2 = "SELECT @returnStatus";
    $result = mysqli_query($conn, $sql2);
    $row = mysqli_fetch_row($result);
    echo $row[0];
    
    echo json_encode($result);
    mysqli_close($conn);
}
*/

require 'DB.php';
//require 'Cors.config.php';

///$method = $_SERVER['REQUEST_METHOD'];
//var_dump($method);
if ($_POST) {
    $usernameExist = verifyByUsername($database, $_POST['username']);
    $emailExist = verifyByEmail($database, $_POST['email']);
    if ($usernameExist == 1) {
        $response['status'] = "Error";
        $response['message'] = "This username is already in use";
    } else if ($emailExist == 1) {
        $response['status'] = "Error";
        $response['message'] = "This email is already in use";
    } else {
        // if ($_POST['password'] == $_POST['password_confirm']) {
        if (($_POST['username'] != null) && ($_POST['email'] != null) && ($_POST['password'] != null)) {

            $username = $_POST['username'];
            $password = password_hash($_POST["password"], PASSWORD_DEFAULT);
            $email = $_POST['email'];
            //   var_dump($username, $password, $account_type, $email);
            createAccount($database, $username, $password, $email);
            $response['status'] = "Success";
            $response['message'] = "Account Created!";
        }
    }
  // header("Content-type: application/json");
    echo json_encode($response);
}



$database = null;



//CREATE ACCOUNT SP call
function createAccount($database, $username, $password, $email)
{
    $sql = 'CALL CREATE_ACCOUNT (?,?,?)';
    $sth = $database->pdo->prepare($sql);

    $sth->bindParam(1, $username, PDO::PARAM_STR, 25);
    $sth->bindParam(2, $password, PDO::PARAM_STR, 255);
    $sth->bindParam(3, $email, PDO::PARAM_STR, 50);
 


    $sth->execute();
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

function verifyByEmail($database, $email)
{
    $sql = 'CALL VERIFY_USER_EXISTS_EMAIL (?)';
    $sth = $database->pdo->prepare($sql);
    $sth->bindParam(1, $email, PDO::PARAM_STR, 50);
    $sth->execute();
    $exist = $sth->fetchAll(PDO::FETCH_ORI_FIRST);
    return $exist[0]["COUNT(*)"];
}