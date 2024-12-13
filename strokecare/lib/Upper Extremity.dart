import 'package:flutter/material.dart';
import 'package:strokecare/wrist.dart';

class Upper extends StatefulWidget {
  final String doctorId;
  final String pid;

  Upper({Key? key, required this.doctorId, required this.pid}) : super(key: key);

  @override
  _UpperState createState() => _UpperState();
}

class _UpperState extends State<Upper> {
  // Declare variables for each assessment checkbox value
  int flexorsValue = 0;
  int extensorsValue = 0;
  int shoulderRetractionValue = 0;
  int shoulderElevationValue = 0;
  int shoulderAbductionValue = 0;
  int shoulderRotationValue = 0;
  int shoulderAdductionValue = 0;
  int elbowFlexionValue = 0;
  int elbowExtensionValue = 0;
  int forearmSupinationValue = 0;
  int forearmPronationValue = 0;
  int handToLumbarSpineValue = 0;
  int shoulderFlexion90Value = 0;
  int pronationSupinationValue = 0;
  int shoulderAbduction90Value = 0;
  int shoulderFlexion180Value = 0;
  int pronationSupinationNoSynergyValue = 0;
  int reflexActivityValue = 0;
  int totalupper = 0;
  void updateTotal() {
    setState(() {
      totalupper = flexorsValue +
          extensorsValue +
          shoulderRetractionValue +
          shoulderElevationValue +
          shoulderAbductionValue +
          shoulderRotationValue +
          shoulderAdductionValue +
          elbowFlexionValue +
          elbowExtensionValue +
          forearmSupinationValue +
          forearmPronationValue +
          handToLumbarSpineValue +
          shoulderFlexion90Value +
          pronationSupinationValue +
          shoulderAbduction90Value +
          shoulderFlexion180Value +
          pronationSupinationNoSynergyValue +
          reflexActivityValue;
    });
  }

  // Method to build a checkbox row
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
                if (label == 'Flexors' ||
                    label == 'Retraction' ||
                    label == 'Flexion' ||
                    label == 'Supination' ||
                    label == 'Hand to lumbar spine\nhand on lap' ||
                    label == 'Shoulder abduction 0 - 90°\nelbow at 0°\nforearm pronated' ||
                    label == 'Biceps, triceps,\nfinger flexors')
                  const Text(
                    '0',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                if (label == 'Flexors' ||
                    label == 'Retraction' ||
                    label == 'Flexion' ||
                    label == 'Supination' ||
                    label == 'Hand to lumbar spine\nhand on lap' ||
                    label == 'Shoulder abduction 0 - 90°\nelbow at 0°\nforearm pronated' ||
                    label == 'Biceps, triceps,\nfinger flexors')
                  const Text(
                    '1',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                if (label == 'Flexors' ||
                    label == 'Retraction' ||
                    label == 'Flexion' ||
                    label == 'Supination' ||
                    label == 'Hand to lumbar spine\nhand on lap' ||
                    label == 'Shoulder abduction 0 - 90°\nelbow at 0°\nforearm pronated' ||
                    label == 'Biceps, triceps,\nfinger flexors')
                  const Text(
                    '2',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                Color(0xFF00CDE2), // Blue
                Color(0xFF00ADFF), // Dark Blue
              ],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(8.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'A. Upper Extremity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'I. Reflex Activity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('Flexors', flexorsValue, (newValue) {
                setState(() {
                  flexorsValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Extensors', extensorsValue, (newValue) {
                setState(() {
                  extensorsValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'II. Volitional Movement within Synergies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Shoulder',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('Retraction', shoulderRetractionValue, (newValue) {
                setState(() {
                  shoulderRetractionValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Elevation', shoulderElevationValue, (newValue) {
                setState(() {
                  shoulderElevationValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Abduction (90°)', shoulderAbductionValue, (newValue) {
                setState(() {
                  shoulderAbductionValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('External rotation', shoulderRotationValue, (newValue) {
                setState(() {
                  shoulderRotationValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Adduction/internal rotation', shoulderAdductionValue, (newValue) {
                setState(() {
                  shoulderAdductionValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'Elbow',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('Flexion', elbowFlexionValue, (newValue) {
                setState(() {
                  elbowFlexionValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Extension', elbowExtensionValue, (newValue) {
                setState(() {
                  elbowExtensionValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'Forearm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('Supination', forearmSupinationValue, (newValue) {
                setState(() {
                  forearmSupinationValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Pronation', forearmPronationValue, (newValue) {
                setState(() {
                  forearmPronationValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'III. Volitional movement mixing synergies',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('Hand to lumbar spine\nhand on lap', handToLumbarSpineValue, (newValue) {
                setState(() {
                  handToLumbarSpineValue = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Shoulder flexion 0°- 90°\nelbow at 0°\npronation-supination 0°', shoulderFlexion90Value, (newValue) {
                setState(() {
                  shoulderFlexion90Value = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Pronation-supination\nelbow at 90°\nshoulder at 0°', pronationSupinationValue, (newValue) {
                setState(() {
                  pronationSupinationValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'IV. Volitional movement\nwith little or no synergy',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('Shoulder abduction 0 - 90°\nelbow at 0°\nforearm pronated', shoulderAbduction90Value, (newValue) {
                setState(() {
                  shoulderAbduction90Value = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Shoulder flexion 90 - 180°\nshoulder at 90° abduction\nforearm supinated', shoulderFlexion180Value, (newValue) {
                setState(() {
                  shoulderFlexion180Value = newValue;
                  updateTotal();
                });
              }),
              buildCheckboxRow('Pronation/supination\nelbow at 0°\nshoulder at about 30° ', pronationSupinationNoSynergyValue, (newValue) {
                setState(() {
                  pronationSupinationNoSynergyValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'V. Reflex activity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              buildCheckboxRow('biceps, triceps,\nfinger flexors', reflexActivityValue, (newValue) {
                setState(() {
                  reflexActivityValue = newValue;
                  updateTotal();
                });
              }),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Total: $totalupper',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Wrist(
                        doctorId: widget.doctorId,
                        pid: widget.pid,
                        totalupper: totalupper, // Pass the total as an integer
                        enteredDays: 1, // Pass the entered days
                      
                      ),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
