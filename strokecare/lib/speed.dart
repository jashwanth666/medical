// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'sensation.dart';
class Speed extends StatefulWidget {
  final String doctorId;
  final String pid;
  final int totalupper;
  final int totalwrist;
  final int totalhand;
  final int enteredDays;

  const Speed({Key? key, required this.doctorId, required this.pid, required this.totalupper, required this.totalwrist, required this.totalhand,  required this.enteredDays,}) : super(key: key);

  @override
  _SpeedState createState() => _SpeedState();
}
class _SpeedState extends State<Speed> {
  int tremorValue = 0;
  int dysmetriaValue = 0;
  int timeValue = 0;
  int totalspeed = 0;
  @override
  void initState() {
    super.initState();
    resetValues();
  }
  void resetValues() {
    setState(() {
      tremorValue = 0;
      dysmetriaValue = 0;
      timeValue = 0;
      totalspeed = 0;
    });
  }
  void updateTotal() {
    setState(() {
      totalspeed = tremorValue + dysmetriaValue + timeValue;
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
            if (label == 'Tremor') ...[
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
            else if (label == 'start and end with\nthe hand on the knee') ...[
              Column(
                children: [
                  const Text('< 2s', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('2 - 5s', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  const Text('≥ 6s', style: TextStyle(fontWeight: FontWeight.bold)),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'D. COORDINATION/SPEED',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
            ),
            const SizedBox(height: 20),
            buildCheckboxRow('Tremor', tremorValue, (newValue) {
              setState(() {
                tremorValue = newValue;
                updateTotal();
              });
            }),
            buildCheckboxRow('Dysmetria', dysmetriaValue, (newValue) {
              setState(() {
                dysmetriaValue = newValue;
                updateTotal();
              });
            }),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                '0 - marked   1 - slight   2 - none',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Time',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            buildCheckboxRow(
              'start and end with\nthe hand on the knee',
              timeValue,
              (newValue) {
                setState(() {
                  timeValue = newValue;
                  updateTotal();
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Total : $totalspeed',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Sensation(doctorId: widget.doctorId,
                        pid: widget.pid, totalhand: widget.totalhand, totalupper:  widget.totalupper, totalwrist: widget.totalwrist,totalspeed:totalspeed,enteredDays: widget.enteredDays,)),
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
    );
  }
}