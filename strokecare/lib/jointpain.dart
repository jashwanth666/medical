import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'dart:convert';
import 'package:strokecare/uril.dart';

import 'score.dart';

class JointPain extends StatefulWidget {
  final String doctorId;
  final String pid;
  final int totalupper;
  final int totalwrist;
  final int totalhand;
  final int totalspeed;
  final int totalsensation;
  final int totaljointmotion;
  final int enteredDays;

  const JointPain({
    Key? key,
    required this.doctorId,
    required this.pid,
    required this.totalupper,
    required this.totalwrist,
    required this.totalhand,
    required this.totalspeed,
    required this.totalsensation,
    required this.totaljointmotion,     
    required this.enteredDays,
  }) : super(key: key); 
  @override
  _JointPainState createState() => _JointPainState();
}
class _JointPainState extends State<JointPain> {
  int shoulderFlexion = 0;
  int shoulderAbduction = 0;
  int shoulderExternalRotation = 0;
  int shoulderInternalRotation = 0;
  int elbowFlexion = 0;
  int elbowExtension = 0;
  int forearmPronation = 0;
  int forearmSupination = 0;
  int wristFlexion = 0;
  int wristExtension = 0;
  int fingersFlexion = 0;
  int fingersExtension = 0;
  int totaljointpain = 0;
  void updateTotal() {
    setState(() {
      totaljointpain = shoulderFlexion +
          shoulderAbduction +
          shoulderExternalRotation +
          shoulderInternalRotation +
          elbowFlexion +
          elbowExtension +
          forearmPronation +
          forearmSupination +
          wristFlexion +
          wristExtension +
          fingersFlexion +
          fingersExtension;
    });
  }
  Future<void> submitData() async {
  final url = Uri.parse('${Urils.Url}/score.php');
  try {
    final response = await http.post(url, body: {
      'doctor_id': widget.doctorId,
      'pid': widget.pid,
      'totalUpper': widget.totalupper.toString(),
      'totalWrist': widget.totalwrist.toString(),
      'totalHand': widget.totalhand.toString(),
      'totalSpeed': widget.totalspeed.toString(),
      'totalSensation': widget.totalsensation.toString(),
      'totalJointMotion': widget.totaljointmotion.toString(),
      'totalJointPain': totaljointpain.toString(),
      'enteredDays': widget.enteredDays.toString(),  // Added enteredDays to POST data
    });
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScorePage(doctorId: widget.doctorId, pid: widget.pid)),
      );
    } else {
      print('Failed to submit data: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

   Widget buildCheckboxRow(String label, int currentValue, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        Row(
          children: [
            Text(label),
            const Spacer(),
            Column(
              children: [
                if (label == 'Flexion (0° - 180°)' || label == 'Pronation' || label == 'Flexion' ) const Text('0',style: TextStyle(fontWeight: FontWeight.bold),),
                Checkbox(
                  value: currentValue == 0,
                  onChanged: (value) {
                    if (value == true) {
                      onChanged(0);
                    }
                  },
                ),
              ],
            ),
            Column(
              children: [
                if (label == 'Flexion (0° - 180°)' || label == 'Pronation' || label == 'Flexion' ) const Text('1',style: TextStyle(fontWeight: FontWeight.bold),),
                Checkbox(
                  value: currentValue == 1,
                  onChanged: (value) {
                    if (value == true) {
                      onChanged(1);
                    }
                  },
                ),
              ],
            ),
            Column(
              children: [
                if (label == 'Flexion (0° - 180°)' || label == 'Pronation' || label == 'Flexion' ) const Text('2',style: TextStyle(fontWeight: FontWeight.bold),),
                Checkbox(
                  value: currentValue == 2,
                  onChanged: (value) {
                    if (value == true) {
                      onChanged(2);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
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
            "Assessment of Patient",
            style: TextStyle(color: Colors.white), // Title text color
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              const Text(
                'J. PASSIVE JOINT PAIN',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text('Shoulder', style: TextStyle(fontWeight: FontWeight.bold)),
              buildCheckboxRow('Flexion (0° - 180°)', shoulderFlexion, (newValue) {
                setState(() {
                  shoulderFlexion = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Abduction (0° - 90°)', shoulderAbduction, (newValue) {
                setState(() {
                  shoulderAbduction = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('External rotation', shoulderExternalRotation, (newValue) {
                setState(() {
                  shoulderExternalRotation = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Internal rotation', shoulderInternalRotation, (newValue) {
                setState(() {
                  shoulderInternalRotation = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text('Elbow', style: TextStyle(fontWeight: FontWeight.bold)),
              buildCheckboxRow('Flexion', elbowFlexion, (newValue) {
                setState(() {
                  elbowFlexion = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Extension', elbowExtension, (newValue) {
                setState(() {
                  elbowExtension = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text('Forearm', style: TextStyle(fontWeight: FontWeight.bold)),
              buildCheckboxRow('Pronation', forearmPronation, (newValue) {
                setState(() {
                  forearmPronation = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Supination', forearmSupination, (newValue) {
                setState(() {
                  forearmSupination = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text('Wrist', style: TextStyle(fontWeight: FontWeight.bold)),
              buildCheckboxRow('Flexion', wristFlexion, (newValue) {
                setState(() {
                  wristFlexion = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Extension', wristExtension, (newValue) {
                setState(() {
                  wristExtension = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text('Fingers', style: TextStyle(fontWeight: FontWeight.bold)),
              buildCheckboxRow('Flexion', fingersFlexion, (newValue) {
                setState(() {
                  fingersFlexion = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Extension', fingersExtension, (newValue) {
                setState(() {
                  fingersExtension = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                '0 - None  1 - partial  2 - full function',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Centered Next button to navigate to the next screen
              const SizedBox(height: 20),
              Text('Total: $totaljointpain', style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: submitData,
                  style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFFCBE9FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}