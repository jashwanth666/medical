<?php
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the Config class
include 'config.php';

// Create a new Config object
$config = new Config();

// Call dbConnect() to establish the connection
if ($config->dbConnect()) {
    $conn = $config->conn; // Get the established connection

    // Prepare your SQL query using mysqli
    $query = "SELECT name, pid FROM patients WHERE doctor_id = ? ORDER BY id DESC LIMIT 5";
    $stmt = $conn->prepare($query);

    // Bind the doctor_id parameter and execute the statement
    $stmt->bind_param('s', $_POST['doctor_id']);
    $stmt->execute();

    $result = $stmt->get_result();
    $patients = array();

    // Fetch all rows
    while ($row = $result->fetch_assoc()) {
        $patients[] = $row;
    }

    // Return the result as a JSON response
    echo json_encode($patients);
} else {
    echo json_encode(['error' => 'Database connection failed']);
}
?>
