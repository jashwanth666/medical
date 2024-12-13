import 'package:flutter/material.dart';
import 'aboutus.dart';
import 'allpatients.dart';
import 'doctordetails.dart';
import 'EditDoctorDetails.dart';
import 'hand.dart';
import 'jointmotion.dart';
import 'jointpain.dart';
import 'login.dart';
import 'registration.dart';
import 'score.dart';
import 'dash.dart';
import 'sensation.dart';
import 'signup.dart';
import 'speed.dart';
import 'Upper Extremity.dart';
import 'wrist.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stroke Care App',
      home: const MainPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/registration': (context) => const RegistrationPage(doctorId: ''),
        '/aboutus': (context) => const AboutUs(doctorId: ''),
        '/dash': (context) => Dashboard(doctorId: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['doctor_id']!,),
        '/EditDoctorDetails': (context) => const EditDoctorDetails(doctorId: ''),
        '/speed': (context) => const Speed(doctorId: '', pid: '', totalupper: 0, totalwrist: 0, totalhand: 0,enteredDays: 0,),
        '/hand': (context) => Hand(doctorId: '', pid: '', totalupper: 0, totalwrist: 0, enteredDays: 0,),
        '/score': (context) => const ScorePage(doctorId: '', pid: '',),
        '/wrist': (context) => const Wrist(doctorId: '', pid: '', totalupper: 0, enteredDays: 0,), // Default value set here
        '/upper': (context) => Upper(doctorId: '', pid: ''),
        '/allpatients': (context) => const AllPatients(doctorId: ''),
        '/totalpatients': (context) => const TotalPatients(doctorId: ''),
        '/doctordetails': (context) => const DoctorDetails(doctorId: ''),
        '/sensation': (context) => const Sensation(doctorId: '', pid: '',totalupper: 0, totalwrist: 0, totalhand: 0,totalspeed: 0,enteredDays: 0,),
        '/jointpain': (context) => const JointPain(doctorId: '', pid: '',totalupper: 0, totalwrist: 0, totalhand: 0,totalspeed: 0, totalsensation: 0, totaljointmotion: 0,enteredDays: 0,),
        '/jointmotion': (context) => const JointMotion(doctorId: '', pid: '',totalupper: 0, totalwrist: 0, totalhand: 0,totalspeed: 0, totalsensation: 0,enteredDays: 0,),
      },
    );
  }
}
class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Stroke \nAid',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 52,
                color: Color(0xFF00ADFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Circular image
            Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF00CDE2), Color(0xFF00ADFF)],
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Image.asset(
                    'assets/images/pprofile_modified.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00CDE2),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
