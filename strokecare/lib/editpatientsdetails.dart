import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:strokecare/uril.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditPatientDetails extends StatefulWidget {
  final String doctorId;
  final String pid;
  const EditPatientDetails({super.key, required this.pid, required this.doctorId});

  @override
  _EditPatientDetailsState createState() => _EditPatientDetailsState();
}

class _EditPatientDetailsState extends State<EditPatientDetails> {
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  File? _selectedImage;
  String? _base64Image;
  String? _fetchedImageUrl;

  @override
  void initState() {
    super.initState();
    _pidController.text = widget.pid;
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    final url = Uri.parse('${Urils.Url}/gotpatients.php');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'pid': widget.pid,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data.containsKey('error')) {
          setState(() {
            _nameController.text = data['name'] ?? '';
            _ageController.text = (data['age'] != null) ? data['age'].toString() : '';
            _genderController.text = data['gender'] ?? '';
            _numberController.text = (data['number'] != null) ? data['number'].toString() : '';
            _addressController.text = data['address'] ?? '';
            _dateController.text = data['date'] ?? '';
            _fetchedImageUrl = data['imagePath'] != null && data['imagePath'].isNotEmpty
                ? '${Urils.Url}/uploads/${data['imagePath']}'
                : null;
          });
        } else {
          throw Exception(data['error']);
        }
      } else {
        throw Exception('Failed to fetch patient details: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _updatePatientDetails() async {
    final url = Uri.parse('${Urils.Url}/updatepatients.php');
    final Map<String, dynamic> body = {
      'pid': widget.pid,
      'name': _nameController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'number': _numberController.text,
      'address': _addressController.text,
      'date': _dateController.text,
    };

    if (_base64Image != null) {
      body['image'] = _base64Image!;
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient details updated successfully')),
          );
          Navigator.pop(context); // Return to previous page
        } else {
          throw Exception(jsonResponse['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to update patient details: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        _base64Image = base64Encode(File(image.path).readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FFFF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65.0),
        child: AppBar(
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
          ),
          title: const Text('Edit Patient Details'),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                    : _fetchedImageUrl != null
                        ? Image.network(
                            _fetchedImageUrl!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(height: 150,width: 150,color: const Color(0xFFCBE9FE),child: const Icon(Icons.person, size: 50),
                              );
                            },
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            color: const Color(0xFFCBE9FE),
                            child: const Icon(Icons.person, size: 50),
                          ),
              ),
            ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Change Image'),
            ),
            const SizedBox(height: 20),
            _buildEditField('PID', _pidController, const Icon(Icons.badge), isReadOnly: true),
            _buildEditField('Name', _nameController, const Icon(Icons.person)),
            _buildEditField('Age', _ageController, const Icon(Icons.calendar_month)),
            _buildEditField('Gender', _genderController, const Icon(Icons.wc)),
            _buildEditField('Mobile', _numberController, const Icon(Icons.phone)),
            _buildEditField('Address', _addressController, const Icon(Icons.location_on)),
            _buildEditField('Date', _dateController, const Icon(Icons.date_range)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _updatePatientDetails,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.lightBlue[200],
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, Icon icon, {bool isReadOnly = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFCBE9FE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1.0), // Added black border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          prefixIcon: icon,
        ),
      ),
    ),
  );
}

}
