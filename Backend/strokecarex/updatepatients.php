<?php
// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set headers for JSON response and handle CORS
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Include the database configuration file
require "config.php"; // Include the config file

// Create a new database object
$db = new Config(); // Change from DataBase to Config

// Check database connection
if (!$db->dbConnect()) {
    echo json_encode(["error" => "Database connection failed."]);
    exit();
}

// Get the raw input data and decode it as JSON
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// Ensure required fields are present
if (isset($data['pid']) && isset($data['name']) && isset($data['age']) && isset($data['gender']) &&
    isset($data['number']) && isset($data['address']) && isset($data['date'])) {

    $pid = $data['pid'];
    $name = $data['name'];
    $age = $data['age'];
    $gender = $data['gender'];
    $number = $data['number'];
    $address = $data['address'];
    $date = $data['date'];
    $imageFilename = '';  // Will store the unique filename to save in the database

    // Check if an image is provided
    if (isset($data['image']) && !empty($data['image'])) {
        // Process the uploaded image
        $image = $data['image'];
        $image = str_replace('data:image/jpeg;base64,', '', $image);  // Handle JPEG images
        $image = str_replace(' ', '+', $image);  // Fix base64 encoding
        $decodedImage = base64_decode($image);

        // Create a unique filename for the image
        $imageFilename = uniqid() . '.jpg';

        // Define the full path to save the image inside the 'uploads' directory
        $uploadDir = 'uploads/';
        $imagePath = $uploadDir . $imageFilename;

        // Save the image to the 'uploads' folder
        if (!file_put_contents($imagePath, $decodedImage)) {
            echo json_encode(["error" => "Failed to save the image."]);
            exit();
        }

        // If an image is provided, update the image path along with other fields
        $sql = "UPDATE patients SET name=?, age=?, gender=?, number=?, address=?, date=?, imagePath=? WHERE pid=?";
        $stmt = $db->conn->prepare($sql);
    } else {
        // If no image is provided, retain the existing image path
        $sql = "UPDATE patients SET name=?, age=?, gender=?, number=?, address=?, date=? WHERE pid=?";
        $stmt = $db->conn->prepare($sql);
    }

    // Check if statement preparation was successful
    if (!$stmt) {
        echo json_encode(["error" => "SQL preparation failed: " . $db->conn->error]);
        exit();
    }

    // Bind parameters
    if (isset($data['image']) && !empty($data['image'])) {
        // Bind parameters including the image path
        $stmt->bind_param("ssssssss", $name, $age, $gender, $number, $address, $date, $imageFilename, $pid);
    } else {
        // Bind parameters without the image path
        $stmt->bind_param("sssssss", $name, $age, $gender, $number, $address, $date, $pid);
    }

    // Execute the query and check for success
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['error' => 'Failed to update patient details: ' . $stmt->error]);
    }

    // Close the statement
    $stmt->close();
} else {
    echo json_encode(['error' => 'Invalid input']);
}

// Close the database connection
$db->conn->close();
?>
