import 'package:flutter/material.dart';
import 'jointmotion.dart';

class Sensation extends StatefulWidget {
  final String doctorId;
  final String pid;
  final int totalupper;
  final int totalwrist;
  final int totalhand;
  final int totalspeed;
  final int enteredDays;

  const Sensation({
    Key? key,
    required this.doctorId,
    required this.pid,
    required this.totalupper,
    required this.totalwrist,
    required this.totalhand,
    required this.totalspeed, 
    required this.enteredDays,
  }) : super(key: key);

  @override
  _SensationState createState() => _SensationState();
}

class _SensationState extends State<Sensation> {
  int upperArmValue = 0;
  int palmSurfaceValue = 0;
  int shoulderValue = 0;
  int wristValue = 0;
  int elbowValue = 0;
  int thumbValue = 0;
  int total = 0;

  void updateTotal() {
    setState(() {
      total = upperArmValue + palmSurfaceValue + shoulderValue + wristValue + elbowValue + thumbValue;
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
                if (label == 'upper arm, forearm' || label == 'shoulder') const Text('0', style: TextStyle(fontWeight: FontWeight.bold)),
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
                if (label == 'upper arm, forearm' || label == 'shoulder') const Text('1', style: TextStyle(fontWeight: FontWeight.bold)),
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
                if (label == 'upper arm, forearm' || label == 'shoulder') const Text('2', style: TextStyle(fontWeight: FontWeight.bold)),
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
              const SizedBox(height: 20),
              const Text(
                'H. SENSATION',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),

              // "Light Touch" bold label above the upper arm, forearm row
              const Text(
                'Light Touch',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Upper arm, forearm with checkboxes and 0, 1, 2 above the checkboxes
              buildCheckboxRow('upper arm, forearm', upperArmValue, (newValue) {
                setState(() {
                  upperArmValue = newValue;
                  updateTotal();
                });
              }),

              // Palm surface of the hand with checkboxes (no 0, 1, 2 labels above checkboxes)
              buildCheckboxRow('palm surface of the hand', palmSurfaceValue, (newValue) {
                setState(() {
                  palmSurfaceValue = newValue;
                  updateTotal();
                });
              }),
              const Center(
                child: Text(
                  '0 - anesthesia  1 - hypoesthesia  2 - normal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Position',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Shoulder with checkboxes and 0, 1, 2 above the checkboxes
              buildCheckboxRow('shoulder', shoulderValue, (newValue) {
                setState(() {
                  shoulderValue = newValue;
                  updateTotal();
                });
              }),

              // Wrist with checkboxes (no 0, 1, 2 labels above checkboxes)
              buildCheckboxRow('wrist', wristValue, (newValue) {
                setState(() {
                  wristValue = newValue;
                  updateTotal();
                });
              }),

              // Elbow with checkboxes (no 0, 1, 2 labels above checkboxes)
              buildCheckboxRow('elbow', elbowValue, (newValue) {
                setState(() {
                  elbowValue = newValue;
                  updateTotal();
                });
              }),

              // Thumb (IP-joint) with checkboxes (no 0, 1, 2 labels above checkboxes)
              buildCheckboxRow('thumb (IP-joint)', thumbValue, (newValue) {
                setState(() {
                  thumbValue = newValue;
                  updateTotal();
                });
              }),

              const SizedBox(height: 20),

              // Description above the Next button
              const Text(
                '0 - less than 3/4 correct or absence\n1 - 3/4 correct or considerable difference\n2 - correct 100%, little or no difference',
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
              // Centered Next button to navigate to JointMotion page
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JointMotion(
                          doctorId: widget.doctorId,
                          pid: widget.pid,
                          totalupper: widget.totalupper,
                          totalwrist: widget.totalwrist,
                          totalhand: widget.totalhand,
                          totalspeed: widget.totalspeed,
                          enteredDays: widget.enteredDays,                          
                          totalsensation: total, // Pass total value to JointMotion
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
