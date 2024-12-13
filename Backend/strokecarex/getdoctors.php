<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set headers for JSON output and CORS policy
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type');

// Include the database configuration file
require "config.php"; // Include your config file

// Create a new Config object
$config = new Config();

// Check database connection using the dbConnect() method
if (!$config->dbConnect()) {
    echo json_encode(["error" => "Database connection failed."]);
    exit();
}

// Get the established database connection
$conn = $config->conn;

// Check if 'doctorId' is provided in the GET request
if (isset($_GET['doctorId'])) {
    // Get doctorId from the GET request and sanitize it
    $doctorId = $conn->real_escape_string($_GET['doctorId']);

    // Prepare the SQL statement
    $sql = "SELECT name, age, gender, mobile, email, specialization, location, hospital_affiliation, imagepath AS image_path 
            FROM doctordetails 
            WHERE doctor_id = ?";
    
    $stmt = $conn->prepare($sql);
    
    // Check if statement preparation was successful
    if (!$stmt) {
        echo json_encode(["error" => "SQL preparation failed: " . $conn->error]);
        exit();
    }

    // Bind the 'doctorId' parameter to the statement
    $stmt->bind_param("s", $doctorId); // "s" denotes that doctorId is a string

    // Execute the SQL statement
    if (!$stmt->execute()) {
        echo json_encode(["error" => "SQL execution failed: " . $stmt->error]);
        exit();
    }

    // Get the result of the query
    $result = $stmt->get_result();

    // Check if any data was found
    if ($result->num_rows > 0) {
        // Fetch the data and output it in JSON format
        $row = $result->fetch_assoc();
        echo json_encode($row);
    } else {
        echo json_encode(["error" => "Doctor not found"]);
    }

    // Close the statement
    $stmt->close();
} else {
    // Return an error if 'doctorId' is not provided in the request
    echo json_encode(["error" => "doctorId parameter missing"]);
}

// Close the database connection (optional)
$conn->close();
?>
