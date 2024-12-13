<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the database configuration
include 'config.php';

// Create a new instance of the Config class and connect to the database
$config = new Config();
if (!$config->dbConnect()) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit();
}

$conn = $config->conn;

// Collect data from POST request
$doctor_id = $_POST['doctor_id'];
$pid = $_POST['pid'];
$totalUpper = $_POST['totalUpper'];
$totalWrist = $_POST['totalWrist'];
$totalHand = $_POST['totalHand'];
$totalSpeed = $_POST['totalSpeed'];
$totalSensation = $_POST['totalSensation'];
$totalJointMotion = $_POST['totalJointMotion'];
$totalJointPain = $_POST['totalJointPain'];
$enteredDays = $_POST['enteredDays'];  // New 'day' field

// Insert data into the 'score' table
$sql = "INSERT INTO score (doctor_id, pid, totalUpper, totalWrist, totalHand, totalSpeed, totalSensation, totalJointMotion, totalJointPain, day) 
        VALUES ('$doctor_id', '$pid', '$totalUpper', '$totalWrist', '$totalHand', '$totalSpeed', '$totalSensation', '$totalJointMotion', '$totalJointPain', '$enteredDays')";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => true, "message" => "Data inserted successfully"]);
} else {
    echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
}

$conn->close();
?>
