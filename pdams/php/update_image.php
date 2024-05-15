<?php
if (isset($_POST['image'])) {
    $image = $_POST['image'];
    $icNumber = $_POST['icNumber'];
    
    $decoded_string = base64_decode($image);
	$path = '../assets/profileimages/'.$icNumber.'.png';
	$pathdir = '../assets/profileimages/';
	if(is_dir($pathdir) && is_writable($pathdir)){
	    $pathok = 'OK';
	} else{
		$pathok = 'FAILED';
	}
	if(file_put_contents($path, $decoded_string)){
		$response = array('status' => 'success', 'data' => $pathok);
		sendJsonResponse($response);
	} else{
		$response = array('status' => 'failed', 'data' => $pathok);
		sendJsonResponse($response);
	}

	
    die();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>