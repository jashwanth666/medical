import 'package:flutter/material.dart';
import 'dash.dart'; // Import your Dashboard page

class AboutUs extends StatelessWidget {
  final String doctorId;

  const AboutUs({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF), // vlblue color
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
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Border radius
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(8.0), // Padding around the title
          child: const Text(
            "About Us",
            style: TextStyle(color: Colors.white), // Title text color
          ),
        ),
      ),
      body: SingleChildScrollView( // Scroll functionality for long content
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stroke Aid',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Stroke is defined as rapidly developing focal or global central neurological disturbance with symptoms lasting 24 hours or longer with no apparent cause other than vascular origin. Stroke is a leading cause of neurologic disability in adults.\n\n"
                      "Virtual reality (VR) rehabilitation is a recent advance in neuroscience and emerging neuroergonomics is a newer safe and effective tool for neurorehabilitation of various neurological conditions.\n\n"
                      "The study is done in two groups in the stroke population. One group receiving both VR rehabilitation and physiotherapy and the other group receiving only physiotherapy and sensorimotor assessment was done using Fugl Meyer Assessment - Upper Extremity (FMA-UA).\n\n"
                      "Stroke Care is an application designed for the primary focus of Fugl Meyer Assessment in stroke patients. The Fugl Meyer Assessment scoring system is a stroke-specific, performance-based impairment index designed to assess sensorimotor functioning. Motor assessment of the upper limb in the stroke population in both groups included in the study group done by using Fugl Meyer Assessment - Upper Extremity.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center( // Center the button horizontally
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Dashboard(doctorId: doctorId), // Navigate to Dashboard
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          backgroundColor: Colors.lightBlue[200], // Button color
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min, // Ensure the button only takes necessary space
                          children: [
                            Icon(Icons.home, color: Colors.black), // Home icon
                            SizedBox(width: 10), // Space between icon and text
                            Text(
                              'Home',
                              style: TextStyle(fontSize: 18, color: Colors.black), // Button text style
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
