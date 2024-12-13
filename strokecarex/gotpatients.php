<?php
// Include the database configuration file

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
require 'config.php'; // Ensure the config.php file is in the same directory or provide the correct path

// Create an instance of the Config class to establish the connection
$config = new Config();

// Check if the connection was successful
if ($config->dbConnect()) { // Make sure to call dbConnect to establish the connection
    // Check if 'pid' is provided in the POST request
    if (isset($_POST['pid'])) {
        $pid = $_POST['pid'];

        // Prepare the SQL query to fetch patient details by 'pid'
        $query = "SELECT name, age, gender, number, pid, address, date, imagePath FROM patients WHERE pid = ?";
        $stmt = $config->conn->prepare($query); // Use the connection from the config object

        if ($stmt) {
            $stmt->bind_param("s", $pid); // Bind the 'pid' parameter

            // Execute the query and check for results
            if ($stmt->execute()) {
                $result = $stmt->get_result();
                if ($result->num_rows > 0) {
                    // Fetch the result as an associative array and return it as JSON
                    $row = $result->fetch_assoc();
                    echo json_encode($row);
                } else {
                    // No matching patient found
                    echo json_encode(['error' => 'Patient not found']);
                }
            } else {
                // Query execution error
                echo json_encode(['error' => 'Query execution failed']);
            }

            // Close the statement
            $stmt->close();
        } else {
            // Statement preparation error
            echo json_encode(['error' => 'SQL preparation failed: ' . $config->conn->error]);
        }
    } else {
        // 'pid' is not provided in the request
        echo json_encode(['error' => 'PID is required']);
    }
} else {
    // Database connection failed
    echo json_encode(['error' => 'Database connection failed']);
}
?>
