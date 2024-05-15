<?php

if ($_SERVER['REQUEST_METHOD'] != 'POST' || !isset($_POST['icNumber'])) {
    $response = array('status' => 'failed', 'message' => 'Invalid request');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$icNumber = $_POST['icNumber'];

$sql = "SELECT * FROM appointment WHERE ICNumber = '$icNumber'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $appointments = array();
    while ($row = $result->fetch_assoc()) {
        $appointment = array(
            'date' => $row['date'],
            'time' => $row['time']
        );
        $appointments[] = $appointment;
    }
    $response = array('status' => 'success', 'appointments' => $appointments);
} else {
    $response = array('status' => 'success', 'appointments' => []);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
