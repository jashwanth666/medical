// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strokecare/uril.dart';
import 'dart:convert';
import 'dart:async';  // For the Timer
import 'allpatients.dart';
import 'doctordetails.dart';
import 'aboutus.dart';
import 'login.dart';
import 'registration.dart';
import 'patientdata.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class Dashboard extends StatefulWidget {
  final String doctorId;  // Doctor's ID
  const Dashboard({super.key, required this.doctorId});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;  // Home is center (selected by default)
  String doctorName = "Loading...";
  String doctorEmail = "Loading...";

  List recentPatients = []; // List to store recent patients data

  // Image slider variables
  int _currentImageIndex = 0;
  late Timer _timer;
  late PageController _pageController;
  final List<String> images = [
    'assets/images/doc2.jpg',
    'assets/images/doc3.jpg',
    'assets/images/doc4.jpg',
    'assets/images/VR-Stroke_56.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
    _fetchRecentPatients(); // Fetch recent patients on initialization

    // Initialize PageController and Timer for the image slider
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % images.length;
      });
      _pageController.animateToPage(
        _currentImageIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();  // Dispose of the timer when the page is closed
    _pageController.dispose();  // Dispose of the PageController
    super.dispose();
  }

  Future<void> _fetchDoctorDetails() async {
    final response = await http.get(Uri.parse('${Urils.Url}/navi.php?doctorId=${widget.doctorId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('error')) {
        setState(() {
          doctorName = "Doctor not found";
          doctorEmail = "N/A";
        });
      } else {
        setState(() {
          doctorName = data['name'];
          doctorEmail = data['email'];
        });
      }
    } else {
      setState(() {
        doctorName = "Error fetching data";
        doctorEmail = "N/A";
      });
    }
  }

  Future<void> _fetchRecentPatients() async {
    final response = await http.post(
      Uri.parse('${Urils.Url}/fetchdash.php'),
      body: {'doctor_id': widget.doctorId},
    );

    if (response.statusCode == 200) {
      setState(() {
        recentPatients = json.decode(response.body); // Parse and set the patient data
      });
    } else {
      throw Exception('Failed to load recent patients');
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllPatients(doctorId: widget.doctorId)),
      );
    } else if (index == 1) {
      // Stay on the current page (Home)
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegistrationPage(doctorId: widget.doctorId)),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorDetails(doctorId: widget.doctorId)),
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
              colors: [
                Color(0xFF00CDE2),
                Color(0xFF00ADFF),
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        title: const Text('Home'),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00CDE2),
                    Color(0xFF00ADFF),
                  ],
                ),
              ),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                accountName: Text(doctorName),
                accountEmail: Text(doctorEmail),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/doctor.png'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Stroke Aid'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs(doctorId: widget.doctorId)),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,  // Align content to the top
    children: [
      // Image slider at the top
      SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.asset(images[index], fit: BoxFit.cover);
          },
        ),
      ),
      const SizedBox(height: 20),  // Add spacing below the image slider

      // "List of patients" text aligned to the left
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Text(
          'List of patients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 10), // Spacing between text and patient list

      // Recent patients list
      recentPatients.isEmpty
          ? const Text('No patients found.')
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),  // Disable scrolling for the list itself
              shrinkWrap: true, // Ensure it takes minimum space
              itemCount: recentPatients.length,
              itemBuilder: (context, index) {
                final patient = recentPatients[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Container(
  decoration: BoxDecoration(
    color: const Color(0xFFB2EAFC), // Background color for the patient box
    borderRadius: BorderRadius.circular(10.0), // Rounded corners
    border: Border.all(  // Add a black border
      color: Colors.black,
      width: 1.0, // Set the thickness of the border
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Shadow color
        spreadRadius: 2, // Spread of the shadow
        blurRadius: 5, // Blur effect
        offset: const Offset(0, 3), // Offset of the shadow
      ),
    ],
  ),
  child: ListTile(
    title: Text(
      patient['name'],
      style: const TextStyle(fontWeight: FontWeight.bold), // Bold text for patient name
    ),
    subtitle: Text("Patient ID: ${patient['pid']}"),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PatientData(
            doctorId: widget.doctorId,
            pid: patient['pid'],
          ),
        ),
      );
    },
  ),
),
                );
              },
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
}