<?php
include 'config.php';

if (isset($_GET['doctorId'])) {
    $doctorId = htmlspecialchars(strip_tags($_GET['doctorId'])); // Sanitize input
    $config = new Config();
    if ($config->dbConnect()) {
        // Fetch patients and their scores
        $query = "
            SELECT 
                p.id AS patient_id, 
                p.name, 
                p.age, 
                p.gender, 
                p.number, 
                p.address, 
                p.date, 
                s.totalUpper, 
                s.totalWrist, 
                s.totalHand, 
                s.totalSpeed, 
                s.totalSensation, 
                s.totalJointMotion, 
                s.totalJointPain, 
                s.day
            FROM 
                patients p
            LEFT JOIN 
                score s 
            ON 
                p.pid = s.pid
            WHERE 
                p.doctor_id = ?
            ORDER BY 
                p.id, s.day ASC
        ";

        $stmt = $config->conn->prepare($query);
        $stmt->bind_param("s", $doctorId);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result && $result->num_rows > 0) {
            // Set headers for CSV download
            header('Content-Type: text/csv');
            header('Content-Disposition: attachment; filename="patients_with_scores.csv"');
            header('Pragma: no-cache');
            header('Expires: 0');
            
            $output = fopen('php://output', 'w');
            // Add headers in the specified order
            fputcsv($output, [
                'ID', 'Name', 'Age', 'Gender', 'Number', 'Address', 'Date', 'Day',
                'Total Upper', 'Total Wrist', 'Total Hand', 
                'Total Speed', 'Total Sensation', 'Total Joint Motion', 'Total Joint Pain'
            ]);

            $previousPid = null; // Track the previous PID to group scores
            while ($row = $result->fetch_assoc()) {
                $currentPid = $row['patient_id'];

                if ($previousPid === null || $previousPid !== $currentPid) {
                    // Print row for a new patient or first occurrence
                    fputcsv($output, [
                        $row['patient_id'], 
                        $row['name'], 
                        $row['age'], 
                        $row['gender'], 
                        $row['number'], 
                        $row['address'], 
                        $row['date'], 
                        $row['day'], 
                        $row['totalUpper'], 
                        $row['totalWrist'], 
                        $row['totalHand'], 
                        $row['totalSpeed'], 
                        $row['totalSensation'], 
                        $row['totalJointMotion'], 
                        $row['totalJointPain']
                    ]);
                } else {
                    // For subsequent scores of the same patient, leave patient details empty
                    fputcsv($output, [
                        '', // Leave ID empty
                        '', // Leave Name empty
                        '', // Leave Age empty
                        '', // Leave Gender empty
                        '', // Leave Number empty
                        '', // Leave Address empty
                        '', // Leave Date empty
                        $row['day'], 
                        $row['totalUpper'], 
                        $row['totalWrist'], 
                        $row['totalHand'], 
                        $row['totalSpeed'], 
                        $row['totalSensation'], 
                        $row['totalJointMotion'], 
                        $row['totalJointPain']
                    ]);
                }

                $previousPid = $currentPid; // Update previous PID tracker
            }

            fclose($output);
            exit();
        } else {
            echo "No patients or scores found for the given doctor.";
            exit();
        }
    } else {
        echo "Database connection failed!";
        exit();
    }
} else {
    echo "Doctor ID not provided!";
    exit();
}
?>
