import 'package:flutter/material.dart';
import 'package:strokecare/uril.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:http/http.dart' as http;
import 'patientdata.dart'; // Import your patient data page
import 'registration.dart'; // Import RegistrationPage for adding new patients
import 'download.dart'; // Import Download page

class AllPatients extends StatefulWidget {
  final String doctorId;

  const AllPatients({Key? key, required this.doctorId}) : super(key: key);

  @override
  _AllPatientsState createState() => _AllPatientsState();
}

class _AllPatientsState extends State<AllPatients> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  List patients = []; // List to store patient data
  bool isLoading = true; // To indicate loading state

  @override
  void initState() {
    super.initState();
    fetchPatients(); // Fetch patient data when the widget is initialized
  }

  Future<void> fetchPatients() async {
    final response = await http.post(
      Uri.parse("${Urils.Url}/fetchpatients.php"),
      body: {
        'doctor_id': widget.doctorId, // Send doctor ID to fetch respective patients
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body); // Parse JSON data
        isLoading = false; // Stop loading after data is fetched
      });
    } else {
      setState(() {
        isLoading = false; // Stop loading even on failure
      });
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF), // Background color
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
        title: const Text('Patient Data',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator()) // Show a loader while fetching data
            : patients.isEmpty
                ? _buildNoDataView() // If no patients, show message and button to add patients
                : _buildPatientListView(), // Else show the list of patients
      ),
    );
  }

  // Widget to build the view when no patients are available
  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Sorry, no patient available",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RegistrationPage(doctorId: widget.doctorId), // Navigate to RegistrationPage
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              backgroundColor: const Color(0xFF00CDE2), // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Add Patients',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build the list of patients
  Widget _buildPatientListView() {
    return Column(
      children: [
        const Text(
          'Recent Added Patients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: patients.length, // Use the length of patients list
            itemBuilder: (context, index) {
              final patient = patients[index]; // Get each patient's data
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientData(
                        doctorId: widget.doctorId,
                        pid: patient['pid'], // Pass patient ID
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 70, // Adjusted height to better fit the layout
                  margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin between buttons
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBE9FE), // Button color
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Colors.black, // Add a border for emphasis
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 20, // Slightly smaller radius for the background circle
                          backgroundColor: Colors.white, // White background circle
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/patient.png', // Image path
                              width: 34, // Image width
                              height: 34, // Image height
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        patient['name'], // Display patient's name
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TotalPatients(doctorId: widget.doctorId), // Navigate to TotalPatients
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: const Color(0xFF00CDE2), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'View All\n Patients',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 15), // Add some spacing between the buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Download(doctorId: widget.doctorId), // Navigate to Download
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  backgroundColor: const Color(0xFF00CDE2), // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Download \n Patients',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class TotalPatients extends StatefulWidget {
  final String doctorId;

  const TotalPatients({Key? key, required this.doctorId}) : super(key: key);

  @override
  _TotalPatientsState createState() => _TotalPatientsState();
}

class _TotalPatientsState extends State<TotalPatients> {
  List patients = []; // List to store all patient data
  TextEditingController searchController = TextEditingController(); // Text controller for the search bar

  @override
  void initState() {
    super.initState();
    fetchAllPatients(); // Fetch all patients data when the widget is initialized
  }

  Future<void> fetchAllPatients({String search = ''}) async {
    final response = await http.post(
      Uri.parse("${Urils.Url}/fetchallpatients.php"), // Replace with your actual URL
      body: {
        'doctor_id': widget.doctorId, // Pass the doctor ID
        'search': search, // Pass the search query
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body); // Parse JSON data
      });
    } else {
      throw Exception('Failed to load patients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF), // Background color
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF00CDE2), // blue
                Color(0xFF00ADFF), // dark blue
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)), // Border radius
          ),
        ),
        title: const Text("All Patients", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92), // Height of the search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                fetchAllPatients(search: value); // Fetch patients based on the search query
              },
              decoration: InputDecoration(
                hintText: 'Search Patients by name',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: patients.isNotEmpty
            ? ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientData(
                            doctorId: widget.doctorId, // Pass the doctor ID as needed
                            pid: patient['pid'], // Pass patient ID
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 70, // Adjusted height for layout consistency
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBE9FE), // Button color
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: Colors.black),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 20, // Background circle size
                              backgroundColor: Colors.white, // Circle background color
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/patient.png', // Path to patient image
                                  width: 34,
                                  height: 34,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            patient['name'], // Display patient's name
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  "Sorry, no patient available", // Message when no patients are found
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
      ),
    );
  }
}
