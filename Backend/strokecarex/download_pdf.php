<?php
require('fpdf.php');  // Include the FPDF library
include 'config.php';

if (isset($_GET['doctorId'])) {
    $doctorId = htmlspecialchars(strip_tags($_GET['doctorId']));  // Sanitize input

    $config = new Config();
    if ($config->dbConnect()) {
        $patients = $config->getPatients($doctorId);  // Fetch patients for this doctor

        // Create a new PDF instance
        $pdf = new FPDF();
        $pdf->AddPage();

        // Set title and font
        $pdf->SetFont('Arial', 'B', 16);
        $pdf->Cell(200, 10, 'Patient Data', 0, 1, 'C');
        $pdf->Ln(10);

        // Set font for table headers
        $pdf->SetFont('Arial', 'B', 12);
        $pdf->Cell(20, 10, 'ID', 1);
        $pdf->Cell(40, 10, 'Name', 1);
        $pdf->Cell(20, 10, 'Age', 1);
        $pdf->Cell(20, 10, 'Gender', 1);
        $pdf->Cell(30, 10, 'Number', 1);
        $pdf->Cell(30, 10, 'PID', 1);
        $pdf->Cell(50, 10, 'Address', 1);
        $pdf->Ln();

        // Set font for data rows
        $pdf->SetFont('Arial', '', 12);

        if ($patients && count($patients) > 0) {
            foreach ($patients as $patient) {
                $pdf->Cell(20, 10, $patient['id'], 1);
                $pdf->Cell(40, 10, $patient['name'], 1);
                $pdf->Cell(20, 10, $patient['age'], 1);
                $pdf->Cell(20, 10, $patient['gender'], 1);
                $pdf->Cell(30, 10, $patient['number'], 1);
                $pdf->Cell(30, 10, $patient['pid'], 1);
                $pdf->Cell(50, 10, $patient['address'], 1);
                $pdf->Ln();
            }
        } else {
            $pdf->Cell(200, 10, 'No data available', 0, 1, 'C');
        }

        // Output the PDF with appropriate headers
        header('Content-Type: application/pdf');
        header('Content-Disposition: attachment; filename="patients.pdf"');
        $pdf->Output();
        exit();
    } else {
        echo "Database connection failed!";
    }
} else {
    echo "Doctor ID not provided!";
}
?>
