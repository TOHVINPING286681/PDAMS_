<?php
if (!isset($_POST['date'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    exit();
}

$currentDate = $_POST['date'];
include_once("dbconnect.php");

$currentDate = date("Y-m-d", strtotime($currentDate));

$query = "SELECT ID, date FROM appointment";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $sqlUpdates = []; 
    while ($row = $result->fetch_assoc()) {
        $appointmentId = $row['ID'];
        $appointmentDate = $row['date'];
        $appointmentDateString = date("Y-m-d", strtotime($appointmentDate));
        
        if (strtotime($appointmentDateString) > strtotime($currentDate)) {
            $status = 'Upcoming';
        } else {
            $status = 'Past';
        }
        $sqlUpdates[] = "UPDATE appointment SET status = '$status' WHERE ID = $appointmentId";
    }
 
    foreach ($sqlUpdates as $sql) {
        if (!$conn->query($sql)) {
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
            exit(); 
        }
    }

    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
