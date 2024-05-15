<?php
if (!isset($_POST['id'], $_POST['state'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    exit(); 
}

$id = $_POST['id'];
$state = $_POST['state'];


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
    $sqlupdate = "UPDATE appointment SET state ='$state' WHERE ID='$id'";
    databaseUpdate($conn, $sqlupdate);
}  else {
       
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    


$conn->close();
?>

