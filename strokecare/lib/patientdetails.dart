import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:strokecare/uril.dart';

import 'package:http/http.dart' as http; // For making HTTP requests

class PatientDetails extends StatefulWidget {
  final String doctorId;
  final String pid;

  const PatientDetails({Key? key, required this.doctorId, required this.pid}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  // Variables to store fetched patient data
  String name = '';
  String age = '';
  String gender = '';
  String number = '';
  String address = '';
  String date = '';
  String imagePath = '';

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
  }

  Future<void> fetchPatientDetails() async {
    final url = Uri.parse('${Urils.Url}/gotpatients.php'); // Replace with actual server URL
    final response = await http.post(url, body: {'pid': widget.pid});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('error')) {
        // Handle error case
        print(data['error']);
      } else {
        // Update the state with fetched data, casting age to String
        setState(() {
          name = data['name'] ?? '';
          age = (data['age'] ?? '').toString(); // Cast age to String
          gender = data['gender'] ?? '';
          number = data['number'] ?? '';
          address = data['address'] ?? '';
          date = data['date'] ?? '';
          imagePath = data['imagePath'] ?? ''; // Store image path
        });
      }
    } else {
      print('Error fetching patient details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00CDE2),
                  Color(0xFF00ADFF),
                ],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
          title: const Text('Patient Details'),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipOval(
                child: _buildPatientImage(), // Build the patient image based on fetched data
              ),
            ),
            const SizedBox(height: 20),
            buildDetailBox(context, Icons.badge, 'Patient ID', widget.pid),
            buildDetailBox(context, Icons.person, 'Name', name),
            buildDetailBox(context, Icons.calendar_month, 'Age', age),
            buildDetailBox(context, Icons.wc, 'Gender', gender),
            buildDetailBox(context, Icons.phone, 'Number', number),
            buildDetailBox(context, Icons.home, 'Address', address),
            buildDetailBox(context, Icons.calendar_today, 'Date', date),
          ],
        ),
      ),
    );
  }

  // Function to build patient image based on the imagePath
  Widget _buildPatientImage() {
    return imagePath.isNotEmpty
        ? Image.network(
            '${Urils.Url}/uploads/$imagePath',
            height: 150,
            width: 150,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _defaultPatientIcon();
            },
          )
        : _defaultPatientIcon();
  }

  // Default patient icon if no image or error loading image
  Widget _defaultPatientIcon() {
    return Container(
      height: 150,
      width: 150,
      color: const Color(0xFFCBE9FE),
      child: const Icon(Icons.person, size: 50),
    );
  }

  // Widget to create a box container for each detail row
  Widget buildDetailBox(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFCBE9FE),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black, // Black border color
            width: 1.0, // Border thickness
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
