<?php
if ($_SERVER['REQUEST_METHOD'] != 'POST' || !isset($_POST['icNumber'], $_POST['name'], $_POST['patientName'], $_POST['patientICNumber'], $_POST['appointmentName'], $_POST['date'], $_POST['time'], $_POST['type'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$ICNumber = $_POST['icNumber'];
$name = $_POST['name'];
$patientName = $_POST['patientName'];
$patientICNumber = $_POST['patientICNumber'];
$appointmentName = $_POST['appointmentName'];
$date = $_POST['date'];
$time = $_POST['time'];
$type = $_POST['type'];

$sql = "INSERT INTO appointment (ICNumber, name, patientName, patientICNumber, appointmentName, date, time, type)
        VALUES ('$ICNumber', '$name', '$patientName', '$patientICNumber', '$appointmentName', '$date', '$time', '$type')";

if ($conn->query($sql) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
} else {
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
