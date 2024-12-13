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
    echo json_encode(["error" => "Database connection failed."]);
    exit();
}

// Fetch the most recent score data
$sql = "SELECT * FROM score ORDER BY id DESC LIMIT 1";
$stmt = $config->conn->prepare($sql); // Prepare the SQL statement

// Execute the query
$stmt->execute();

// Fetch associative array
$row = $stmt->get_result()->fetch_assoc(); // Get the result and fetch as associative array

if ($row) {
    // Convert integer values to strings
    foreach ($row as $key => $value) {
        if (is_int($value)) {
            $row[$key] = (string)$value; // Convert to string
        }
    }
    echo json_encode($row); // Return the result as JSON
} else {
    echo json_encode(['error' => 'No data found']); // No data found message
}

// Close the statement
$stmt->close();

// Close the database connection
$config->conn->close(); // Close the PDO connection
?>
