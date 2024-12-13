<?php

header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Methods: GET, POST, OPTIONS"); // Allow GET, POST, and OPTIONS methods
header("Access-Control-Allow-Headers: Content-Type, Authorization");
require "Config.php"; // Include the database connection class

// Create an instance of the Config class
$config = new Config();

if (isset($_POST['name']) && isset($_POST['email']) && isset($_POST['username']) && isset($_POST['password'])) {
    if ($config->dbConnect()) { // Check if database connection is successful
        if (slogin($config, "login", $_POST['name'], $_POST['email'], $_POST['username'], $_POST['password'])) {
            echo "Sign Up Success"; // Successful sign-up
        } else {
            echo "Sign Up Failed"; // Sign-up failed
        }
    } else {
        echo "Error: Database connection"; // Database connection error
    }
} else {
    echo "Please fill all required fields (Name, Email, Username, and Password)"; // Validation error
}

// Function to handle the signup process
function slogin($config, $table, $name, $email, $username, $password)
{
    // Sanitize inputs
    $name = htmlspecialchars($name);
    $email = htmlspecialchars($email);
    $username = htmlspecialchars($username);
    $password = htmlspecialchars($password);

    // Hash the password
    $password = password_hash($password, PASSWORD_DEFAULT);

    // Generate a unique doctor_id
    $doctor_id = generateDoctorId(rand(3, 5)); // Generate a doctor ID with 3 to 5 characters

    // Begin a transaction
    $config->conn->begin_transaction();

    try {
        // Insert into the login table
        $sql = "INSERT INTO $table (doctor_id, name, email, username, password) VALUES (?, ?, ?, ?, ?)";
        $stmt = $config->conn->prepare($sql);
        if (!$stmt) {
            throw new Exception("SQL preparation failed for login table: " . $config->conn->error);
        }
        $stmt->bind_param("sssss", $doctor_id, $name, $email, $username, $password);
        if (!$stmt->execute()) {
            throw new Exception("Insert into login failed: " . $stmt->error);
        }

        // Now insert into the doctordetails table
        $sql = "INSERT INTO doctordetails (doctor_id, name, email) VALUES (?, ?, ?)";
        $insertStmt = $config->conn->prepare($sql);
        if (!$insertStmt) {
            throw new Exception("SQL preparation failed for doctordetails table: " . $config->conn->error);
        }
        $insertStmt->bind_param("sss", $doctor_id, $name, $email);
        if (!$insertStmt->execute()) {
            throw new Exception("Insert into doctordetails failed: " . $insertStmt->error);
        }

        // Commit transaction
        $config->conn->commit();
        return true; // Success
    } catch (Exception $e) {
        // Rollback transaction in case of error
        $config->conn->rollback();
        error_log($e->getMessage()); // Log the error message
        return false; // Failed
    } finally {
        // Close the prepared statements
        $stmt->close();
        if (isset($insertStmt)) {
            $insertStmt->close();
        }
    }
}

// Function to generate a doctor ID with random letters and numbers
function generateDoctorId($length = 5)
{
    $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    $randomString = '';

    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }

    return 'doc_' . $randomString; // Concatenate 'doc_' with the random string
}
?>
