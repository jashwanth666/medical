import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:strokecare/uril.dart';

class Download extends StatelessWidget {
  final String doctorId;

  const Download({Key? key, required this.doctorId}) : super(key: key);

  // Function to request storage permission
  Future<void> requestPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isDenied) {
        final status = await Permission.manageExternalStorage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enable storage permissions in settings.")),
          );
          await openAppSettings();
        }
      } 
    }
  }

  // Function to download CSV file
  Future<void> downloadCSV(BuildContext context) async {
  try {
    await requestPermission(context);

    final url = Uri.parse('${Urils.Url}/download_csv.php?doctorId=$doctorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        // Generate the current date as DD-MM-YYYY for the file name
        final now = DateTime.now();
        final dateString = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
        final file = File('$result/patients_$dateString.csv');
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV downloaded to $result as patients_$dateString.csv')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download canceled.')),
        );
      }
    } else {
      throw Exception('Failed to download CSV');
    }
  } catch (e) {
    print('Error downloading CSV: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error downloading CSV')),
    );
  }
}

  // Function to download PDF file
  Future<void> downloadPDF(BuildContext context) async {
  try {
    await requestPermission(context);

    final url = Uri.parse('${Urils.Url}/download_pdf.php?doctorId=$doctorId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        // Generate the current date as DD-MM-YYYY for the file name
        final now = DateTime.now();
        final dateString = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
        final file = File('$result/patients_$dateString.pdf');
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF downloaded to $result as patients_$dateString.pdf')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download canceled.')),
        );
      }
    } else {
      throw Exception('Failed to download PDF');
    }
  } catch (e) {
    print('Error downloading PDF: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error downloading PDF')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF00CDE2), Color(0xFF00ADFF)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        

        title: const Text(
          'Download Patients',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F8FF), Color(0xFFDBEAF9)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.cloud_download_outlined,
                  size: 80,
                  color: Color(0xFF00ADFF),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select the Download Type',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your preferred file format below:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => downloadCSV(context),
                icon: const Icon(Icons.file_download),
                label: const Text('Download as CSV'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color(0xFF00CDE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 5,
                  foregroundColor: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () => downloadPDF(context),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Download as PDF'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color(0xFF00CDE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: Colors.black.withOpacity(0.2),
                  elevation: 5,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}