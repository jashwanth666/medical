import 'package:flutter/material.dart';
import 'package:strokecare/hand.dart';

class Wrist extends StatefulWidget {
  final String doctorId;
  final String pid;
  final int totalupper;
  final int enteredDays;

  const Wrist({
    Key? key,
    required this.doctorId,
    required this.pid,
    required this.totalupper, 
    required this.enteredDays,
  }) : super(key: key);

  @override
  _WristState createState() => _WristState();
}

class _WristState extends State<Wrist> {
  int stability15Dorsiflexion1Value = 0;
  int repeatedDorsiflexion1Value = 0;
  int stability15Dorsiflexion2Value = 0;
  int repeatedDorsiflexion2Value = 0;
  int circumductionValue = 0;
  int totalwrist = 0;
  
  get enteredDays => 0;

  // No need for a null totalupper getter
  // Instead, directly use widget.totalupper when needed

  void updateTotal() {
    setState(() {
      totalwrist = stability15Dorsiflexion1Value +
          repeatedDorsiflexion1Value +
          stability15Dorsiflexion2Value +
          repeatedDorsiflexion2Value +
          circumductionValue;
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
            if (label == 'elbow at 90°,forearm\npronated shoulder at 0°') ...[
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
            ] else ...[
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
  void initState() {
    super.initState();
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
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            "Assessment of Patient", // Updated to display totalupper + totalwrist
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
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
                'B. WRIST',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                '\nStability at 15° dorsiflexion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('elbow at 90°,forearm\npronated shoulder at 0°', stability15Dorsiflexion1Value, (newValue) {
                setState(() {
                  stability15Dorsiflexion1Value = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nRepeated dorsiflexion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('elbow at 90°, forearm\npronated shoulder at 0°,\nslight finger flexion', repeatedDorsiflexion1Value, (newValue) {
                setState(() {
                  repeatedDorsiflexion1Value = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nStability at 15° dorsiflexion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('elbow at 0°, forearm\npronated slight shoulder\nflexion', stability15Dorsiflexion2Value, (newValue) {
                setState(() {
                  stability15Dorsiflexion2Value = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nRepeated dorsiflexion / volar flexion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('elbow at 0°, forearm\npronated slight shoulder\nflexion', repeatedDorsiflexion2Value, (newValue) {
                setState(() {
                  repeatedDorsiflexion2Value = newValue;
                  updateTotal();
                });
              }),
              const Text(
                '\nCircumduction',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('elbow at 90°, forearm\npronated shoulder at 0°', circumductionValue, (newValue) {
                setState(() {
                  circumductionValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                '0 - None  1 - partial  2 - full function',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Total: $totalwrist',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Hand(
                        doctorId: widget.doctorId,
                        pid: widget.pid,
                        totalupper: widget.totalupper, // Pass the totalupper correctly
                        totalwrist: totalwrist,
                        enteredDays: widget.enteredDays, // Pass the entered days
                        
                      )
                      
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