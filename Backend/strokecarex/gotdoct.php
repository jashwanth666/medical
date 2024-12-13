<?php
require "Config.php"; // Include the database connection class

// Instantiate the Config class
$config = new Config();

// Check if the connection was successful
if ($config->conn) {
    if (isset($_GET['doctorId'])) {
        $doctorId = $_GET['doctorId'];

        // Prepare the SQL statement to prevent SQL injection
        $stmt = $config->conn->prepare("SELECT * FROM doctordetails WHERE doctor_id = ?");
        $stmt->execute([$doctorId]);

        // Fetch the result
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            // Return the result as JSON
            echo json_encode($result);
        } else {
            echo json_encode(['error' => 'Doctor not found']);
        }

        // Close the statement
        $stmt = null;
    } else {
        echo json_encode(['error' => 'No doctor ID provided']);
    }
} else {
    echo json_encode(['error' => 'Database connection failed']);
}
?>
