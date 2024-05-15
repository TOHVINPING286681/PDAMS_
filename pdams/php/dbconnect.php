<?php

$servername = "localhost";
$username   = "id22098114_vp_0826";
$password   = "@Tvp010826010539";
$dbname     = "id22098114_pdams";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


/*web hosting
$servername = "127.0.0.1";
$username   = "root";
$password   = "";
$dbname     = "pdams";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);

}
*/

?>


