import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:strokecare/uril.dart';

class ScoreResult extends StatefulWidget {
  final String doctorId;
  final String pid;

  ScoreResult({Key? key, required this.doctorId, required this.pid}) : super(key: key);

  @override
  _ScoreResultState createState() => _ScoreResultState();
}

class _ScoreResultState extends State<ScoreResult> {
  List<Map<String, dynamic>> scoreData = [];
  String message = ''; // Variable to hold the message when no data is found

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    final response = await http.post(
      Uri.parse('${Urils.Url}/fetch_score.php'), // Replace with your server URL
      body: {
        'doctor_id': widget.doctorId,
        'pid': widget.pid,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>; // List of dynamic objects

      if (data.isEmpty) {
        // If there is no data, update the message
        setState(() {
          message = 'Sorry, there is no data found in the database. Please add new data.';
          scoreData = []; // Clear the scoreData
        });
      } else {
        setState(() {
          scoreData = data.map((score) {
            return {
              'day': score['day'] != null ? 'Day - ${score['day']}' : 'No Day Available',
              'A. UPPER EXTREMITY': score['totalUpper'] != null ? '${score['totalUpper']} / 36' : 'N/A / 36',
              'B. WRIST': score['totalWrist'] != null ? '${score['totalWrist']} / 10' : 'N/A / 10',
              'C. HAND': score['totalHand'] != null ? '${score['totalHand']} / 14' : 'N/A / 14',
              'D. COORDINATION / SPEED': score['totalSpeed'] != null ? '${score['totalSpeed']} / 6' : 'N/A / 6',
              'TOTAL A-D (motor function)': (score['totalUpper'] != null &&
                      score['totalWrist'] != null &&
                      score['totalHand'] != null &&
                      score['totalSpeed'] != null)
                  ? (int.parse(score['totalUpper'].toString()) +
                          int.parse(score['totalWrist'].toString()) +
                          int.parse(score['totalHand'].toString()) +
                          int.parse(score['totalSpeed'].toString()))
                      .toString() + ' / 66'
                  : 'N/A / 66',
              'H. SENSATION': score['totalSensation'] != null ? '${score['totalSensation']} / 12' : 'N/A / 12',
              'I. PASSIVE JOINT MOTION': score['totalJointMotion'] != null ? '${score['totalJointMotion']} / 24' : 'N/A / 24',
              'J. JOINT PAIN': score['totalJointPain'] != null ? '${score['totalJointPain']} / 24' : 'N/A / 24',
            };
          }).toList();
          message = ''; // Clear the message if data is found
        });
      }
    } else {
      throw Exception('Failed to load scores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF00CDE2), Color(0xFF00ADFF)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        title: const Text('Patient Score'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: scoreData.isEmpty
            ? Center(
                child: message.isNotEmpty
                    ? Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      )
                    : const CircularProgressIndicator(), // Show loading indicator if no data yet
              )
            : ListView(
                children: scoreData.map((dayScores) {
                  return buildScoreCard(dayScores);
                }).toList(),
              ),
      ),
    );
  }

  Widget buildScoreCard(Map<String, dynamic> scores) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.lightBlue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the day at the top of each card, use a default value if null
            Text(
              scores['day'] ?? 'Day Not Available', // Check if the 'day' key is null
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: scores.entries
                  .where((entry) => entry.key != 'day') // Skip displaying the 'day' key in the remaining rows
                  .map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Gap between boxes
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 75, // Increased width for all value boxes
                        height: 40, // Fixed height for all value boxes
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white, // White background for the value box
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            entry.value,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
