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
$doctorID= $_POST['doctorID'];
//$medicine= $_POST['medicine'];
$password = sha1($_POST['password']);


//$sqlinsert = "INSERT INTO clinicdoctor (name, ICNumber, email, password, gender, bloodType, doctorID, medicine)
//VALUES ('$name', '$icNumber', '$email', '$password', '$gender', '$bloodType', '$doctorID', '$medicine')";
$sqlinsert = "INSERT INTO clinicdoctor (name, ICNumber, email, password, gender, bloodType, doctorID)
VALUES ('$name', '$icNumber', '$email', '$password', '$gender', '$bloodType', '$doctorID')";

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