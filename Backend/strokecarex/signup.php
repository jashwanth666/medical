<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
require "config.php";
$db = new Config();

// Retrieve the input data (decode the JSON)
$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['name']) && isset($data['age']) && isset($data['gender']) && isset($data['number']) && isset($data['pid']) && isset($data['address']) && isset($data['date']) && isset($data['image']) && isset($data['doctor_id'])) {
    if ($db->dbConnect()) {
        if ($db->pidExists($data['pid'])) {
            echo "PID already exists. Please change it!";
        } else {
            // Decode and save the image
            $imageData = $data['image'];
            $imageData = base64_decode($imageData);
            $imageFilename = uniqid() . '.jpg';
            $uploadDir = 'uploads/';
            $imagePath = $uploadDir . $imageFilename;

            if (!file_put_contents($imagePath, $imageData)) {
                echo "Failed to save the image.";
                exit();
            }

            // Store the filename in the database
            if ($db->signUp("patients", $data['name'], $data['age'], $data['gender'], $data['number'], $data['pid'], $data['address'], $data['date'], $imageFilename, $data['doctor_id'])) {
                echo "patients entry Success";
            } else {
                echo "patients entry Failed";
            }
        }
    } else {
        echo "Error: Database connection failed.";
    }
} else {
    echo "Error: All fields are required.";
}
?>
