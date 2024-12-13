import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:strokecare/uril.dart';
import 'package:http/http.dart' as http;
import 'EditDoctorDetails.dart';
import 'dart:io';
import 'allpatients.dart';
import 'registration.dart';
import 'dash.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
class DoctorDetails extends StatefulWidget {
  final String doctorId;
  const DoctorDetails({super.key, required this.doctorId});
  @override
  _DoctorDetailsState createState() => _DoctorDetailsState();
}
class _DoctorDetailsState extends State<DoctorDetails> {
  String name = "Loading...";
  String age = "Loading...";
  String gender = "Loading...";
  String mobile = "Loading...";
  String email = "Loading...";
  String specialization = "Loading...";
  String location = "Loading...";
  String hospitalAffiliation = "Loading...";
  String imagePath = '';
  File? selectedImage;
  int _selectedIndex = 3;  // Profile tab index
  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    final response = await http.get(
        Uri.parse('${Urils.Url}/getdoctors.php?doctorId=${widget.doctorId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('error')) {
        setState(() {
          name = "Doctor not found";
        });
      } else {
        setState(() {
          name = data['name'] ?? 'N/A';
          age = data['age'] ?? 'N/A';
          gender = data['gender'] ?? 'N/A';
          mobile = data['mobile'] ?? 'N/A';
          email = data['email'] ?? 'N/A';
          specialization = data['specialization'] ?? 'N/A';
          location = data['location'] ?? 'N/A';
          hospitalAffiliation = data['hospital_affiliation'] ?? 'N/A';
          imagePath = data['image_path'] ?? '';
        });
      }
    } else {
      setState(() {
        name = "Error fetching data";
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllPatients(doctorId: widget.doctorId)),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard(doctorId: widget.doctorId)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage(doctorId: widget.doctorId)),
      );
    } else if (index == 3) {
      // Stay on the current page (Profile)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF),
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
          title: const Text('Doctor Profile'),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: ClipOval(
                child: imagePath.isNotEmpty
                    ? Image.network(
                        '${Urils.Url}/uploads/$imagePath',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                          return const Icon(Icons.error, size: 50);
                        },
                      )
                    : Container(
                        height: 150,
                        width: 150,
                        color: const Color(0xFFCBE9FE),
                        child: const Icon(Icons.person, size: 50),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            _buildViewField('Doctor ID', widget.doctorId, Icons.badge),
            _buildViewField('Name', name, Icons.person),
            _buildViewField('Age', age, Icons.calendar_month),
            _buildViewField('Gender', gender, Icons.wc),
            _buildViewField('Mobile', mobile, Icons.phone),
            _buildViewField('Email', email, Icons.email),
            _buildViewField('Specialization', specialization, Icons.school),
            _buildViewField('Location', location, Icons.location_on),
            _buildViewField('Hospital/Clinic Affiliation', hospitalAffiliation, Icons.local_hospital),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDoctorDetails(
                        doctorId: widget.doctorId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.lightBlue[200],
                ),
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: const Color.fromARGB(255, 0, 200, 255),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00CDE2),
            Color(0xFF00ADFF),
          ],
        ),
        style: TabStyle.reactCircle,
        items: const [
          TabItem(icon: Icons.list_alt, title: 'Patients'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add_circle, title: 'Add Patient'),
          TabItem(icon: Icons.medical_services, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped, 
        curveSize: 80,
      ),
    );
  }

  Widget _buildViewField(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFCBE9FE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,  // Set the border color to black
          width: 1.0,  // Set the border thickness to 1.0
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
          const SizedBox(width: 10), // Spacing between icon and label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  softWrap: true,
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
