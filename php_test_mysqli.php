<?php

$mysqli_connection = new MySQLi('host', 'user', 'pass', 'db');
if ($mysqli_connection->connect_error) {
   echo "Not connected, error: " . $mysqli_connection->connect_error;
}
else {
   echo "Connected.";
}

?>
