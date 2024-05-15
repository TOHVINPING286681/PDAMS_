<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
if (isset($_POST['icNumber'])){
    $icNumber = $_POST['icNumber'];  
    $sqlloadappointment = "SELECT * FROM appointment WHERE (ICNumber = '$icNumber' OR patientICNumber = '$icNumber')";
    
    $result = $conn->query($sqlloadappointment);
$number_of_result = $result->num_rows;
    if ($result->num_rows > 0) {
		$appointments["appointments"] = array();
        
        while ($row = $result->fetch_assoc()) {
            $appointment = array(); 
			$appointment['ID'] = $row['ID'];
            $appointment['ICNumber'] = $row['ICNumber'];
            $appointment['name'] = $row['name'];
            $appointment['patientName'] = $row['patientName'];
            $appointment['patientICNumber'] = $row['patientICNumber'];
            $appointment['appointmentName'] = $row['appointmentName'];
            $appointment['date'] = $row['date'];
            $appointment['time'] = $row['time'];
            $appointment['type'] = $row['type'];
            $appointment['status'] = $row['status'];
			$appointment['state'] = $row['state'];

            array_push($appointments["appointments"], $appointment); 
        }
        $response = array('status' => 'success', 'data' => $appointments, 'numberofresult'=>"$number_of_result");
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
