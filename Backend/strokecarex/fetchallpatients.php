<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the database configuration file
require "config.php"; 

// Create an instance of the Config class
$config = new Config();

// Check if the connection was successful
if ($config->dbConnect()) {
    // Check if doctor_id is provided in the POST request
    if (isset($_POST['doctor_id'])) {
        $doctor_id = $_POST['doctor_id']; // Get doctor_id from POST
        $search = isset($_POST['search']) ? $_POST['search'] : ''; // Optional search query

        // Base query to fetch patients for the specified doctor_id
        $sql = "SELECT name, pid FROM patients WHERE doctor_id = ?";

        // If there's a search term, append to the query
        if (!empty($search)) {
            $sql .= " AND name LIKE ?";
        }

        // Prepare the SQL statement
        $stmt = $config->conn->prepare($sql);

        // Bind parameters
        if (!empty($search)) {
            $searchParam = '%' . $search . '%';
            $stmt->bind_param("ss", $doctor_id, $searchParam); // "ss" indicates two string parameters
        } else {
            $stmt->bind_param("s", $doctor_id); // "s" indicates one string parameter
        }

        // Execute the query
        $stmt->execute();

        // Fetch the results
        $result = $stmt->get_result();
        $patients = $result->fetch_all(MYSQLI_ASSOC); // Fetch all results as an associative array

        // Return the result as JSON
        echo json_encode($patients);
    } else {
        echo json_encode(['error' => 'doctor_id is required']);
    }
} else {
    echo json_encode(['error' => 'Database connection failed']);
}

// Optional: close the database connection
$config->conn->close();
?>
