<?php

if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$icNumber = $_POST['icNumber'];
$pass = sha1($_POST['password']);
include_once("dbconnect.php");

$query = "SELECT * FROM governmentdoctor WHERE ICNumber='$icNumber' AND password='$pass'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    
    $user_type = "governmentDoctor";
   		while ($row = $result->fetch_assoc()) {
		$userarray = array();
		$userarray['id'] = $row['ID'];
		$userarray['email'] = $row['email'];
		$userarray['name'] = $row['name'];
		$userarray['icNumber'] = $row['ICNumber'];
		$userarray['password'] = $_POST['password'];
		$userarray['gender'] = $row['gender'];
		$userarray['bloodType'] = $row['bloodType'];
		$userarray['medicine'] = $row['medicine'];
		$userarray['doctorID'] = $row['doctorID'];
		
		$response = array('status' => 'success', 'data' => $userarray);
		sendJsonResponse($response);
	}
} else {

    $query = "SELECT * FROM clinicdoctor WHERE ICNumber='$icNumber' AND password='$pass'";
    $result = $conn->query($query);

    if ($result->num_rows > 0) {
       
        $user_type = "clinicDoctor";
       	while ($row = $result->fetch_assoc()) {
		$userarray = array();
		$userarray['id'] = $row['ID'];
		$userarray['email'] = $row['email'];
		$userarray['name'] = $row['name'];
		$userarray['icNumber'] = $row['ICNumber'];
		$userarray['password'] = $_POST['password'];
		$userarray['gender'] = $row['gender'];
		$userarray['bloodType'] = $row['bloodType'];
		$userarray['medicine'] = $row['medicine'];
		$userarray['doctorID'] = $row['doctorID'];
		
		$response = array('status' => 'success', 'data' => $userarray);
		sendJsonResponse($response);
	}
    } else {
 
        $query = "SELECT * FROM normaluser WHERE ICNumber='$icNumber' AND password='$pass'";
        $result = $conn->query($query);

        if ($result->num_rows > 0) {
     
            $user_type = "user";
            	while ($row = $result->fetch_assoc()) {
		$userarray = array();
		$userarray['id'] = $row['ID'];
		$userarray['email'] = $row['email'];
		$userarray['name'] = $row['name'];
		$userarray['icNumber'] = $row['ICNumber'];
		$userarray['password'] = $_POST['password'];
		$userarray['gender'] = $row['gender'];
		$userarray['bloodType'] = $row['bloodType'];
		$userarray['medicine'] = $row['medicine'];
	
		
		$response = array('status' => 'success', 'data' => $userarray);
		sendJsonResponse($response);
	}
        } else {
          
          $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
        }
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>

