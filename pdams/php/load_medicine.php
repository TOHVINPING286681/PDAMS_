<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
if (isset($_POST['icNumber'])){
    $icNumber = $_POST['icNumber'];  
    $sqlloadmedicine = "SELECT * FROM medicine WHERE patientICNumber = '$icNumber'";
    
    $result = $conn->query($sqlloadmedicine);
$number_of_result = $result->num_rows;
    if ($result->num_rows > 0) {
		$medicines["medicines"] = array();

        while ($row = $result->fetch_assoc()) {
            $medicine = array();
            $medicine['ID'] = $row['ID'];
            $medicine['icNumber'] = $row['ICNumber'];
            $medicine['name'] = $row['name'];
            $medicine['patientName'] = $row['patientName'];
            $medicine['patientICNumber'] = $row['patientICNumber'];
            $medicine['medicineName'] = $row['medicineName'];
            $medicine['date'] = $row['date'];
            $medicine['time'] = $row['time'];
            $medicine['type'] = $row['type'];
            $medicine['timesPerDay'] = $row['timesPerDay'];
            $medicine['doctorID'] = $row['doctorID'];
$medicine['tabletsCapsules'] = $row['tabletsCapsules'];
$medicine['timing'] = $row['timing'];
$medicine['food'] = $row['food'];

            array_push($medicines["medicines"], $medicine);
        }
        $response = array('status' => 'success', 'data' => $medicines, 'numberofresult' => "$number_of_result");
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
