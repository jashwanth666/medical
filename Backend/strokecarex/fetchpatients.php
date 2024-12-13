<?php
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the config.php file for database connection
include 'config.php';

// Create an instance of the Config class and establish the connection
$config = new Config();

// Call dbConnect() to establish the connection
if (!$config->dbConnect()) {
    die(json_encode(["error" => "Database connection failed"]));
}

// Get the established connection from config.php
$conn = $config->conn;

// Check if doctor_id is present in the POST request
if (isset($_POST['doctor_id'])) {
    // Sanitize doctor_id using real_escape_string to prevent SQL injection
    $doctor_id = $conn->real_escape_string($_POST['doctor_id']);

    // Prepare the query to fetch patients for the specified doctor_id
    $sql = "SELECT name, pid FROM patients WHERE doctor_id = ? ORDER BY id DESC LIMIT 10";
    
    // Use a prepared statement to execute the query
    $stmt = $conn->prepare($sql);
    
    // Bind the doctor_id parameter to the statement
    $stmt->bind_param('s', $doctor_id);
    
    // Execute the statement
    $stmt->execute();
    
    // Get the result of the query
    $result = $stmt->get_result();
    
    // Fetch all rows and store them in an array
    $patients = array();
    while ($row = $result->fetch_assoc()) {
        $patients[] = $row;
    }
    
    // Return the result as a JSON response
    echo json_encode($patients);
} else {
    echo json_encode(['error' => 'doctor_id is required']);
}

// Close the database connection (optional, as mysqli closes automatically at the end of the script)
$conn->close();
