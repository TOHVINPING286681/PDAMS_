<?php
if (!isset($_POST['id'], $_POST['icNumber'], $_POST['patientICNumber'], $_POST['date'], $_POST['time'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    exit(); 
}

$id = $_POST['id'];
$icNumber = $_POST['icNumber'];
$patientICNumber = $_POST['patientICNumber'];
$date = $_POST['date'];
$time = $_POST['time'];


include_once("dbconnect.php");

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

function databaseUpdate($conn, $sql)
{
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

$query = "SELECT * FROM appointment WHERE ID='$id'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $sqlupdate = "UPDATE appointment SET date ='$date', time ='$time' WHERE ID='$id'";
    databaseUpdate($conn, $sqlupdate);
}  else {
       
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    


$conn->close();
?>

