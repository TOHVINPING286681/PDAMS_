<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$icNumber = $_POST['icNumber'];
$email = $_POST['email'];
$gender = $_POST['gender'];
$bloodType= $_POST['bloodType'];


$password = sha1($_POST['password']);


$sqlinsert = "INSERT INTO normaluser (name, ICNumber, email, password, gender, bloodType)
VALUES ('$name', '$icNumber', '$email', '$password', '$gender', '$bloodType')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>