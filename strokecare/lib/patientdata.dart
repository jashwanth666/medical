import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http;
import 'adddays.dart';
import 'patientdetails.dart';
import 'package:strokecare/uril.dart';
import 'editpatientsdetails.dart';
import 'scoreresults.dart';
import 'allpatients.dart'; // Import the AllPatients page
class PatientData extends StatefulWidget {
  final String doctorId;
  final String pid;
  const PatientData({Key? key, required this.doctorId, required this.pid}) : super(key: key);
  @override
  _PatientDataState createState() => _PatientDataState();
}
class _PatientDataState extends State<PatientData> {
  String name = '';
  String address = '';
  String number = '';
  bool isLoading = true; // For showing loading state
  @override
  void initState() {
    super.initState();
    fetchPatientData(); // Fetch patient data when the widget is initialized
  }
  Future<void> fetchPatientData() async {
    final response = await http.post(
      Uri.parse("${Urils.Url}/fetchpatientdata.php"), // Replace with your actual URL
      body: {
        'pid': widget.pid, // Send patient ID to fetch respective patient data
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('name')) {
        setState(() {
          name = data['name'];
          address = data['address'];
          number = data['number'];
          isLoading = false; // Data loaded successfully
        });
      } else {
        setState(() {
          name = 'No patient found';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        name = 'Error fetching data';
        isLoading = false;
      });
      throw Exception('Failed to load patient data');
    }
  }
buildDeleteButton(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.redAccent, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 1.0), // Optional black border
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Patient'),
              content: const Text('Are you sure you want to delete this patient?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); 
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    deletePatient(context); 
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.white), 
          ),
          const Icon(Icons.delete, color: Colors.white), 
        ],
      ),
    ),
  );
}
Future<void> deletePatient(BuildContext context) async {
  final response = await http.post(
    Uri.parse("${Urils.Url}/deletepatient.php"), 
    body: {
      'pid': widget.pid, // Send patient ID
     },
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient deleted successfully')),
    );
    
    // Navigate to AllPatients page and pass doctorId
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AllPatients(doctorId: widget.doctorId), // Pass doctorId to the AllPatients page
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to delete patient')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF),
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
        title: const Text('Patient Data'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
          : Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00CDE2), Color(0xFF00ADFF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.78,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Dynamic Patient Information Box
                    Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFFD0E7FF),
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Column(
    children: [
      Text(
        name.isNotEmpty ? name : 'Loading...',
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        address.isNotEmpty ? address : '',
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      const SizedBox(height: 4),
      Text(
        number.isNotEmpty ? number : '',
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
      const SizedBox(height: 20),
      buildDeleteButton(context, 'Delete Patient'), // Add Delete Button here
    ],
  ),
),
                    const SizedBox(height: 15),
                    buildPatientButton(context, 'Patient Details', Icons.arrow_forward, 'patientdetails'),
                    buildPatientButton(context, 'Edit Patient Details', Icons.arrow_forward, 'editpatientdetails'),
                    buildPatientButton(context, 'Score Results', Icons.arrow_forward, 'scoreresults'),
                    buildPatientButton(context, 'Add day', Icons.arrow_forward, 'addday'),
                    const SizedBox(height: 10),
                    // Done Button
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Navigate to AllPatients page when Done is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AllPatients(doctorId: widget.doctorId)), // Ensure to create AllPatients class
                          );
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Color(0xFF2196F3)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
  Widget buildPatientButton(BuildContext context, String title, IconData icon, String route) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0), // Reduced padding between buttons
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFFD0E7FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 1.0), // Added black border with thickness 1.0
        ),
      ),
      onPressed: () {
        switch (route) {
          case 'patientdetails':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientDetails(doctorId: widget.doctorId, pid: widget.pid)), // Pass doctorId and pid
            );
            break;
          case 'editpatientdetails':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditPatientDetails(doctorId: widget.doctorId, pid: widget.pid)), // Pass doctorId and pid
            );
            break;
          case 'scoreresults':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScoreResult(doctorId: widget.doctorId, pid: widget.pid)), // Pass doctorId and pid
            );
            break;
          case 'addday':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Adddays(doctorId: widget.doctorId, pid: widget.pid)), // Pass doctorId and pid
            );
            break;
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black), // Text color changed to black
          ),
          Icon(icon, color: Colors.black), // Icon color also changed to black for consistency
        ],
      ),
    ),
  );
}
}