<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the database configuration
include 'config.php';  

// Create a new instance of the Config class
$config = new Config();

// Check if the connection was successful
if (!$config->dbConnect()) {
    echo json_encode(array("error" => "Database connection failed."));
    exit();
}

// Get doctorId from the request
$doctorId = $_GET['doctorId'];

// SQL query to fetch the doctor's name and email
$sql = "SELECT name, email FROM doctordetails WHERE doctor_id = ?";
$stmt = $config->conn->prepare($sql); // Prepare the SQL statement

// Bind the parameter
$stmt->bind_param("s", $doctorId); // Assuming doctor_id is a string

// Execute the query
$stmt->execute();

// Get the result
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Output the name and email
    $row = $result->fetch_assoc();
    echo json_encode(array("name" => $row['name'], "email" => $row['email']));
} else {
    // If no data is found, return an error message
    echo json_encode(array("error" => "No doctor found with this ID."));
}

// Close the statement
$stmt->close();

// Close the database connection
$config->conn->close();
?>
