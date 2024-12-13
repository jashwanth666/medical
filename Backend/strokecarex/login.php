<?php
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
require "Config.php";
$config = new Config(); 

// Attempt to connect to the database
if ($config->dbConnect()) {
    $conn = $config->conn; // Use the connection from the Config class 

    if (isset($_POST['username']) && isset($_POST['password'])) {
        $username = $_POST['username']; 
        $password = $_POST['password']; 

        // Prepare the query to fetch stored password hash for the provided username
        $query = "SELECT doctor_id, password FROM login WHERE username = ?";
        $stmt = $conn->prepare($query);  // Use $conn instead of $db
        $stmt->bind_param("s", $username); // Bind the username parameter
        $stmt->execute();
        $result = $stmt->get_result();

        // Check if the username exists and validate the password
        if ($result && $result->num_rows > 0) { 
            $row = $result->fetch_assoc(); 
            $storedPasswordHash = $row['password']; // The hashed password in the database
            $doctor_id = $row['doctor_id'];

            // Verify the entered password with the stored password hash
            if (password_verify($password, $storedPasswordHash)) {
                echo json_encode([
                    "status" => "Login Success",
                    "doctor_id" => $doctor_id
                ]);
            } else {
                echo json_encode([
                    "status" => "Username or Password incorrect"
                ]);
            }
        } else {
            echo json_encode([
                "status" => "Username or Password incorrect"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "All fields are required"
        ]);
    }
} else {
    echo json_encode([
        "status" => "Error: Database connection failed"
    ]);
}
?>
