<?php
// Include the database configuration file

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include 'config.php'; // Ensure the path is correct

// Create an instance of the Config class
$config = new Config();

// Check if the connection was successful
if (!$config->dbConnect()) { // Call dbConnect to establish the connection
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit(); // Stop the script execution if connection failed
}

// Check if the `pid` is passed via POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['pid'])) {
        $pid = $config->conn->real_escape_string($_POST['pid']);

        // Start a transaction to ensure both deletions occur or none
        $config->conn->begin_transaction();

        try {
            // SQL to delete from patients table
            $deletePatients = "DELETE FROM patients WHERE pid = '$pid'";
            $config->conn->query($deletePatients);

            // SQL to delete from score table
            $deleteScore = "DELETE FROM score WHERE pid = '$pid'";
            $config->conn->query($deleteScore);

            // Commit the transaction if both queries succeed
            $config->conn->commit();

            // Return success response
            echo json_encode(["success" => true, "message" => "Patient data deleted successfully"]);
        } catch (Exception $e) {
            // Rollback the transaction in case of any failure
            $config->conn->rollback();

            // Return error response
            echo json_encode(["success" => false, "message" => "Error deleting patient data: " . $e->getMessage()]);
        }
    } else {
        // Return error if pid is not set
        echo json_encode(["success" => false, "message" => "Patient ID (pid) not provided"]);
    }
} else {
    // Return error if request method is not POST
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

// Close the database connection (optional, as it will close at the end of the script)
$config->conn->close();
?>
