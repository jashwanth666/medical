import 'package:flutter/material.dart';

import 'jointpain.dart';

class JointMotion extends StatefulWidget {
  final String doctorId;
  final String pid;
  final int totalupper;
  final int totalwrist;
  final int totalhand;
  final int totalspeed;
  final int totalsensation;
  final int enteredDays;

  const JointMotion({
    Key? key,
    required this.doctorId,
    required this.pid,
    required this.totalupper,
    required this.totalwrist,
    required this.totalhand,
    required this.totalspeed,
    required this.totalsensation,
    required this.enteredDays,
  }) : super(key: key);
  @override
  _JointMotionState createState() => _JointMotionState();
}

class _JointMotionState extends State<JointMotion> {
  // Define values for each joint movement and initialize them to 0
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

  int total = 0;

  // Update the total score
  void updateTotal() {
    setState(() {
      total = shoulderFlexion +
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
                'I. PASSIVE JOINT MOTION',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
              ),
              const SizedBox(height: 20),

              // Shoulder movements
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

              // Elbow movements
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

              // Forearm movements
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

              // Wrist movements
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

              // Finger movements
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

              // Total value display
              const Text(
                '0 - None  1 - partial  2 - full function',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Total: $total',
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Centered Next button to navigate to the next screen
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                       MaterialPageRoute(
                        builder: (context) => JointPain(
                          doctorId: widget.doctorId,
                          pid: widget.pid,
                          totalupper: widget.totalupper,
                          totalwrist: widget.totalwrist,
                          totalhand: widget.totalhand,
                          totalspeed: widget.totalspeed,
                          totalsensation: widget.totalsensation,
                          enteredDays: widget.enteredDays, // Pass total value to JointMotion
                          totaljointmotion: total,
                        
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color(0xFFCBE9FE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
