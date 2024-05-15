<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$patientICNumber = $_POST['icNumber'];
$patientName = $_POST['name'];
$medicinename = $_POST['medicinename'];
$timesPerDay= $_POST['timesPerDay'];
$date= $_POST['date'];
$time= $_POST['time'];
$type= $_POST['type'];
$tabletsCapsules= $_POST['tabletsCapsules'];
$timing= $_POST['timing'];
$food= $_POST['food'];


$sqlinsert = "INSERT INTO medicine (date, time, patientICNumber, patientName, type, timesPerDay, medicinename, tabletsCapsules, timing, food)
VALUES ('$date','$time','$patientICNumber', '$patientName', '$type', '$timesPerDay', '$medicinename', '$tabletsCapsules', '$timing', '$food')";

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