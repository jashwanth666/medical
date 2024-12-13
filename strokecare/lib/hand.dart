import 'package:flutter/material.dart';
import 'speed.dart';

class Hand extends StatefulWidget {
  final String doctorId;
  final String pid;
  final int totalupper;
  final int totalwrist;
  
  final int enteredDays;

  Hand({
    Key? key,
    required this.doctorId,
    required this.pid,
    required this.totalupper,
    required this.totalwrist, 
    required this.enteredDays,
  }) : super(key: key);

  @override
  _HandState createState() => _HandState();
}

class _HandState extends State<Hand> {
  int massFlexionValue = 0;
  int massExtensionValue = 0;
  int hookGraspValue = 0;
  int thumbAdductionValue = 0;
  int pincerGraspValue = 0;
  int cylinderGraspValue = 0;
  int sphericalGraspValue = 0;
  int totalhand = 0;

  void updateTotal() {
    setState(() {
      totalhand = massFlexionValue +
          massExtensionValue +
          hookGraspValue +
          thumbAdductionValue +
          pincerGraspValue +
          cylinderGraspValue +
          sphericalGraspValue;
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
            // If the label is 'Tremor', show 0, 1, 2 above the checkboxes
            if (label == 'from full active or\npassive extension') ...[
              Column(
                children: [
                  const Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('2', style: TextStyle(fontWeight: FontWeight.bold)),
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
            ]
            // If the label is 'Time', show < 2s, 2 - 5s, ≥ 6s above the checkboxes
            else if (label == 'flexion in PIP and DIP\n(digits II-V), extension\nin MCP II-V') ...[
              Column(
                children: [
                  const Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('2', style: TextStyle(fontWeight: FontWeight.bold)),
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
            ]
            // For other labels (like 'Dysmetria'), just show the checkboxes without labels above
            else ...[
              Checkbox(
                value: currentValue == 0,
                onChanged: (value) {
                  if (value == true) {
                    onChanged(0);
                  }
                },
              ),
              Checkbox(
                value: currentValue == 1,
                onChanged: (value) {
                  if (value == true) {
                    onChanged(1);
                  }
                },
              ),
              Checkbox(
                value: currentValue == 2,
                onChanged: (value) {
                  if (value == true) {
                    onChanged(2);
                  }
                },
              ),
            ],
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
          padding: const EdgeInsets.all(8.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Assessment of Patient",
                style: TextStyle(color: Colors.white),
              ),
              
            ],
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
                'C. HAND',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                '\nMass flexion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Mass Flexion with checkboxes and 0, 1, 2 above the checkboxes
              buildCheckboxRow('from full active or\npassive extension', massFlexionValue, (newValue) {
                setState(() {
                  massFlexionValue = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nMass extension',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Mass Extension with checkboxes
              buildCheckboxRow('from full active or \npassive flexion', massExtensionValue, (newValue) {
                setState(() {
                  massExtensionValue = newValue;
                  updateTotal();
                });
              }),
              const Text(
                'GRASP',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '\na. Hook grasp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Hook grasp with checkboxes and 0, 1, 2 above the checkboxes
              buildCheckboxRow('flexion in PIP and DIP\n(digits II-V), extension\nin MCP II-V', hookGraspValue, (newValue) {
                setState(() {
                  hookGraspValue = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nb. Thumb adduction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Thumb adduction with checkboxes
              buildCheckboxRow('1st CMC, MCP, IP at 0°,\n scrap of paper between\nthumb and 2nd MCP joint', thumbAdductionValue, (newValue) {
                setState(() {
                  thumbAdductionValue = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nc. Pincer grasp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Pincer grasp with checkboxes
              buildCheckboxRow('opposition pulp of the\nthumb against the pulp of\n2nd finger, pencil,\ntug upward', pincerGraspValue, (newValue) {
                setState(() {
                  pincerGraspValue = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nd. Cylinder grasp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Cylinder grasp with checkboxes
              buildCheckboxRow('cylinder-shaped object\ntug upward, opposition of\nthumb and fingers', cylinderGraspValue, (newValue) {
                setState(() {
                  cylinderGraspValue = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\ne. Spherical grasp',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Spherical grasp with checkboxes
              buildCheckboxRow('fingers in abduction/\nflexion, thumb opposed,\ntennis ball, tug away', sphericalGraspValue, (newValue) {
                setState(() {
                  sphericalGraspValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              // Display total
              const SizedBox(height: 20),
            Center(
              child: Text(
                'Total : $totalhand',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Speed page with totals
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Speed(
                        doctorId: widget.doctorId,
                        pid: widget.pid,
                        totalupper: widget.totalupper,
                        totalwrist: widget.totalwrist,
                        enteredDays: widget.enteredDays, // Pass the entered days
                        totalhand: totalhand,
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
            ],
          ),
        ),
      ),
    );
  }
}
