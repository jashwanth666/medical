import 'dart:convert';
import 'package:strokecare/uril.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strokecare/dash.dart';

class ScorePage extends StatelessWidget {
  final String doctorId;
  final String pid;

  const ScorePage({
    Key? key,
    required this.doctorId,
    required this.pid,
  }) : super(key: key);

  // Function to fetch data from the database
  Future<Map<String, dynamic>> fetchScoreData() async {
    final response = await http.post(
      Uri.parse('${Urils.Url}/fetchdata.php'),
      body: {
        'doctor_id': doctorId,
        'pid': pid,
      },
    );

    if (response.statusCode == 200) {
      // Assuming the response is a JSON object
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load score data');
    }
  }

  // Helper widget to create score rows
  Widget scoreRow({required String label, required String score, required String total}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ),
        Row(
          children: [
            Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  score,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Text('/'),
            const SizedBox(width: 5),
            Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  total,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Function to calculate total A-D score
  String getTotal(Map<String, dynamic> scoreData) {
    int upper = int.parse(scoreData['totalUpper'] ?? 0);
    int wrist = int.parse(scoreData['totalWrist'] ?? '0');
    int hand = int.parse(scoreData['totalHand'] ?? '0');
    int speed = int.parse(scoreData['totalSpeed'] ?? '0');
    return (upper + wrist + hand + speed).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Score'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00CDE2), Color(0xFF00ADFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF5FFFF), // Background color
        child: Center(
          child: Container(
            height: 550,
            width: 350,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00CDE2), Color(0xFF00ADFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchScoreData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found'));
                } else {
                  final scoreData = snapshot.data!;
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Patient Score:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // First Container with scores A-D
                        Container(
                          height: 235,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5FFFF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'A. Upper Extremity',
                                score: (scoreData['totalUpper'] ?? 0).toString(),
                                total: '36',
                              ),
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'B. WRIST',
                                score: (scoreData['totalWrist'] ?? 0).toString(),
                                total: '10',
                              ),
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'C. HAND',
                                score: (scoreData['totalHand'] ?? 0).toString(),
                                total: '14',
                              ),
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'D. COORDINATION / SPEED',
                                score: (scoreData['totalSpeed'] ?? 0).toString(),
                                total: '6',
                              ),
                            ],
                          ),
                        ),
                        // Total A-D
                        Container(
                          height: 80,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5FFFF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'TOTAL A-D\n(motor function)',
                                score: getTotal(scoreData),
                                total: '66',
                              ),
                            ],
                          ),
                        ),
                        // Second Container with scores H-J
                        Container(
                          height: 180,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5FFFF),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'H. SENSATION',
                                score: (scoreData['totalSensation'] ?? 0).toString(),
                                total: '12',
                              ),
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'I. PASSIVE JOINT\nMOTION',
                                score: (scoreData['totalJointMotion'] ?? 0).toString(),
                                total: '24',
                              ),
                              const SizedBox(height: 14),
                              scoreRow(
                                label: 'J. JOINT PAIN',
                                score: (scoreData['totalJointPain'] ?? 0).toString(),
                                total: '24',
                              ),
                            ],
                          ),
                        ),
                        // Done Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Dashboard(doctorId: doctorId),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              backgroundColor: Colors.lightBlue[200],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_outline_sharp, size: 24, color: Color.fromARGB(255, 37, 244, 44)),
                                SizedBox(width: 10),
                                Text(
                                  'Done',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
