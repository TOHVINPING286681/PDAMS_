<?php

include_once("dbconnect.php");

if(isset($_POST['icNumber']) && isset($_POST['date']) && isset($_POST['time'])) {
    $patientICNumber = $_POST['icNumber'];
    $date = $_POST['date'];
    $time = $_POST['time'];

    // Prepare SQL query to check if the slot is available for the given patient
    $sql = "SELECT * FROM appointment WHERE patientICNumber = '$patientICNumber' AND date = '$date' AND time = '$time' AND ICNumber = patientICNumber" ;

    // Execute the query
    $result = mysqli_query($conn, $sql);

    // If any appointment exists for the given patient, date, and time, slot is not available
    $available = mysqli_num_rows($result) == 0 ? true : false;

    // Return JSON response
    echo json_encode(array('available' => $available));
} else {
    // Handle invalid request
    echo json_encode(array('error' => 'Invalid request.'));
}

?>
