<?php
if (!isset($_POST['icNumber'], $_POST['name'], $_POST['bloodType'], $_POST['email'], $_POST['gender'], $_POST['medicine'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    exit(); 
}

$icNumber = $_POST['icNumber'];
$name = $_POST['name'];
$bloodType = $_POST['bloodType'];
$email = $_POST['email'];
$gender = $_POST['gender'];
$medicine = $_POST['medicine'];

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

$query = "SELECT * FROM governmentdoctor WHERE ICNumber='$icNumber'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $sqlupdate = "UPDATE governmentdoctor SET name ='$name', bloodType = '$bloodType', email ='$email', gender ='$gender', medicine ='$medicine' WHERE ICNumber = '$icNumber'";
    databaseUpdate($conn, $sqlupdate);
} else {
    $query = "SELECT * FROM clinicdoctor WHERE ICNumber='$icNumber'";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE clinicdoctor SET name ='$name', bloodType = '$bloodType', email ='$email', gender ='$gender', medicine ='$medicine' WHERE ICNumber = '$icNumber'";
        databaseUpdate($conn, $sqlupdate);
    } else {
        $query = "SELECT * FROM normaluser WHERE ICNumber='$icNumber'";
        $result = $conn->query($query);

        if ($result->num_rows > 0) {
            // User is a normal user
            $sqlupdate = "UPDATE normaluser SET name ='$name', bloodType = '$bloodType', email ='$email', gender ='$gender', medicine ='$medicine' WHERE ICNumber = '$icNumber'";
            databaseUpdate($conn, $sqlupdate);
        } else {
            // Invalid credentials
            $response = array('status' => 'failed', 'data' => null);
            sendJsonResponse($response);
        }
    }
}

$conn->close();
?>
