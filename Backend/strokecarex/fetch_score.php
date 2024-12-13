<?php 
header('Content-Type: application/json');  

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
// Include the configuration file
include 'config.php';  

// Create an instance of the Config class
$config = new Config();

// Check if the connection was successful
if (!$config->dbConnect()) {
    echo json_encode(["error" => "Database connection failed."]);
    exit();
}

// Fetching doctor_id and pid from POST request
$doctorId = $_POST['doctor_id'];
$pid = $_POST['pid'];

// Fetch scores based on doctor_id and pid
$sql = "SELECT * FROM score WHERE doctor_id = ? AND pid = ? ORDER BY day ASC";
$stmt = $config->conn->prepare($sql);

// Bind parameters
$stmt->bind_param("ss", $doctorId, $pid); // Assuming both are strings

// Execute the query
$stmt->execute();
$result = $stmt->get_result(); // Get the result set from the executed statement
$scores = [];

// Fetch results
while ($row = $result->fetch_assoc()) {
    $scores[] = [
        'totalUpper' => $row['totalUpper'],
        'totalWrist' => $row['totalWrist'],
        'totalHand' => $row['totalHand'],
        'totalSpeed' => $row['totalSpeed'],
        'totalSensation' => $row['totalSensation'],
        'totalJointMotion' => $row['totalJointMotion'],
        'totalJointPain' => $row['totalJointPain'],
        'day' => $row['day']
    ];
}

// Return the scores as JSON
echo json_encode($scores);

// Close the connection
$stmt->close(); // Close the statement
$config->conn->close(); // Close the connection
?>
