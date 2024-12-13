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
if (isset($data['doctorId']) && isset($data['name']) && isset($data['age']) && isset($data['gender']) &&
    isset($data['mobile']) && isset($data['email']) && isset($data['specialization']) &&
    isset($data['location']) && isset($data['hospital_affiliation'])) {

    $doctorId = $data['doctorId'];
    $name = $data['name'];
    $age = $data['age'];
    $gender = $data['gender'];
    $mobile = $data['mobile'];
    $email = $data['email'];
    $specialization = $data['specialization'];
    $location = $data['location'];
    $hospital_affiliation = $data['hospital_affiliation'];
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
        $sql = "UPDATE doctordetails SET name=?, age=?, gender=?, mobile=?, email=?, specialization=?, location=?, hospital_affiliation=?, imagepath=? WHERE doctor_id=?";
    } else {
        // If no image is provided, retain the existing image path
        $sql = "UPDATE doctordetails SET name=?, age=?, gender=?, mobile=?, email=?, specialization=?, location=?, hospital_affiliation=? WHERE doctor_id=?";
    }

    // Prepare the SQL statement
    $stmt = $db->conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["error" => "SQL preparation failed: " . $db->conn->error]);
        exit();
    }

    // Bind parameters
    if (isset($data['image']) && !empty($data['image'])) {
        // Bind parameters including the image path
        $stmt->bind_param("ssssssssss", $name, $age, $gender, $mobile, $email, $specialization, $location, $hospital_affiliation, $imageFilename, $doctorId);
    } else {
        // Bind parameters without the image path
        $stmt->bind_param("sssssssss", $name, $age, $gender, $mobile, $email, $specialization, $location, $hospital_affiliation, $doctorId);
    }

    // Execute the query and check for success
    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['error' => 'Failed to update doctor details: ' . $stmt->error]);
    }

    // Close the statement
    $stmt->close();
} else {
    echo json_encode(['error' => 'Invalid input']);
}

// Close the database connection
$db->conn->close();
?>
