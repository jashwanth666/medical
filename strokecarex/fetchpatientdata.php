<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the database configuration file
require 'config.php'; // Ensure the config.php file is in the same directory or provide the correct path

// Create an instance of the Config class to establish the connection
$config = new Config();

// Check if the connection was successful
if ($config->dbConnect()) { // Make sure to call dbConnect to establish the connection
    if (isset($_POST['pid'])) {
        $pid = $_POST['pid'];

        // Fetch patient details (name, address, number) based on pid
        $query = "SELECT name, address, number FROM patients WHERE pid = ?";
        $stmt = $config->conn->prepare($query);

        if ($stmt) {
            $stmt->bind_param('s', $pid);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $data = $result->fetch_assoc();
                echo json_encode($data); // Return data as JSON
            } else {
                echo json_encode(['message' => 'No patient found']);
            }

            $stmt->close();
        } else {
            echo json_encode(['error' => 'SQL preparation failed: ' . $config->conn->error]);
        }
    } else {
        echo json_encode(['error' => 'PID is required']);
    }
} else {
    echo json_encode(['error' => 'Database connection failed']); // Connection failed message
}

// No need to close the connection manually if it’s null
?>
