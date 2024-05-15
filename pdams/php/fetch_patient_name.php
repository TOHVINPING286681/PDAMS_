<?php

if (!isset($_POST['patientICNumber'])) {
    $response = array('status' => 'failed', 'patientName' => null);
    sendJsonResponse($response);
    die();
}

$patientICNumber = $_POST['patientICNumber'];

include_once("dbconnect.php");

$query = "SELECT name FROM governmentdoctor WHERE ICNumber='$patientICNumber'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $patientName = $row['name'];

    $response = array('status' => 'success', 'patientName' => $patientName);
    sendJsonResponse($response);
    die(); 
}


$query = "SELECT name FROM clinicdoctor WHERE ICNumber='$patientICNumber'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $patientName = $row['name'];

    $response = array('status' => 'success', 'patientName' => $patientName);
    sendJsonResponse($response);
    die();
}
$query = "SELECT name FROM normaluser WHERE ICNumber='$patientICNumber'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $patientName = $row['name'];

    $response = array('status' => 'success', 'patientName' => $patientName);
    sendJsonResponse($response);
    die(); 
}

$response = array('status' => 'failed', 'patientName' => null);
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
