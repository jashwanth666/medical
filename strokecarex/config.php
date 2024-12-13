<?php
class Config {
    private $host = 'localhost';
    private $user = 'root'; // Your database username
    private $password = ''; // Your database password
    private $database = 'doctor'; // Your database name
    public $conn; // Database connection property

    // Establish a database connection
    public function dbConnect() {
        $this->conn = new mysqli($this->host, $this->user, $this->password, $this->database);
        if ($this->conn->connect_error) {
            return false; // Connection failed
        }
        return true; // Connection successful
    }

    // Check if a PID exists
    public function pidExists($pid) {
        $query = "SELECT COUNT(*) FROM patients WHERE pid = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("s", $pid);
        $stmt->execute();
        $stmt->bind_result($count);
        $stmt->fetch();
        $stmt->close(); // Close the statement
        return $count > 0; // Return true if PID exists
    }

    // Sign up a patient
    public function signUp($table, $name, $age, $gender, $number, $pid, $address, $date, $image, $doctor_id) {
        $query = "INSERT INTO $table (name, age, gender, number, pid, address, date, imagePath, doctor_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("sisssssss", $name, $age, $gender, $number, $pid, $address, $date, $image, $doctor_id);
        $result = $stmt->execute();
        $stmt->close(); // Close the statement
        return $result; // Return the result of the execution
    }

    // Fetch patients for a specific doctor
    public function getPatients($doctorId) {
        $query = "SELECT * FROM patients WHERE doctor_id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("s", $doctorId);
        $stmt->execute();
        $result = $stmt->get_result();
        $patients = $result->fetch_all(MYSQLI_ASSOC);
        $stmt->close(); // Close the statement
        return $patients; // Return the list of patients
    }
}
?>
