<?php

include_once("dbconnect.php");


if(isset($_POST['icNumber']) && isset($_POST['date']) && isset($_POST['time'])) {
    $icNumber = $_POST['icNumber'];
    $date = $_POST['date'];
    $time = $_POST['time'];


    $sql = "SELECT * FROM appointment WHERE (ICNumber = '$icNumber' OR patientICNumber = '$icNumber') AND date = '$date' AND time = '$time'";


    $result = mysqli_query($conn, $sql);


    $available = mysqli_num_rows($result) == 0 ? true : false;

   
    echo json_encode(array('available' => $available));
} else {
    
    echo json_encode(array('error' => 'Invalid request.'));
}

?>
