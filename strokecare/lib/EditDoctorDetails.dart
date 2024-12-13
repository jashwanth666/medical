import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:strokecare/uril.dart';

import 'doctordetails.dart'; // Import the DoctorDetails page

class EditDoctorDetails extends StatefulWidget {
  final String doctorId;
  const EditDoctorDetails({super.key, required this.doctorId});

  @override
  _EditDoctorDetailsState createState() => _EditDoctorDetailsState();
}

class _EditDoctorDetailsState extends State<EditDoctorDetails> {
  final TextEditingController _doctorIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  File? _selectedImage;
  String? _base64Image;
  String? _fetchedImageUrl;

  @override
  void initState() {
    super.initState();
    _doctorIdController.text = widget.doctorId;
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    final response = await http.get(
      Uri.parse('${Urils.Url}/getdoctors.php?doctorId=${widget.doctorId}')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (!data.containsKey('error')) {
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = data['age'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _mobileController.text = data['mobile'] ?? '';
          _emailController.text = data['email'] ?? '';
          _specializationController.text = data['specialization'] ?? '';
          _locationController.text = data['location'] ?? '';
          _hospitalController.text = data['hospital_affiliation'] ?? '';

          // Fetch the image URL if available
          _fetchedImageUrl = data['imagePath'] != null && data['imagePath'].isNotEmpty
              ? '${Urils.Url}/uploads/${data['imagePath']}'
              : null;
        });
      }
    }
  }

  Future<void> _updateDoctorDetails() async {
    final url = Uri.parse('${Urils.Url}/updatedoctors.php');

    final Map<String, dynamic> body = {
      'doctorId': widget.doctorId,
      'name': _nameController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'mobile': _mobileController.text,
      'email': _emailController.text,
      'specialization': _specializationController.text,
      'location': _locationController.text,
      'hospital_affiliation': _hospitalController.text,
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
            const SnackBar(content: Text('Doctor details updated successfully')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetails(doctorId: widget.doctorId),
            ),
          );
        } else {
          throw Exception(jsonResponse['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to update doctor details: ${response.statusCode}');
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
          title: const Text('Edit Doctor Profile'),
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
                              return Container(
                                height: 150,
                                width: 150,
                                color: const Color(0xFFCBE9FE),
                                child: const Icon(Icons.person, size: 50),
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
            _buildEditField('Doctor ID', _doctorIdController, const Icon(Icons.badge), isReadOnly: true),
            _buildEditField('Name', _nameController, const Icon(Icons.person)),
            _buildEditField('Age', _ageController, const Icon(Icons.calendar_month)),
            _buildEditField('Gender', _genderController, const Icon(Icons.wc)),
            _buildEditField('Mobile', _mobileController, const Icon(Icons.phone)),
            _buildEditField('Email', _emailController, const Icon(Icons.email)),
            _buildEditField('Specialization', _specializationController, const Icon(Icons.school)),
            _buildEditField('Location', _locationController, const Icon(Icons.location_on)),
            _buildEditField('Hospital/Clinic Affiliation', _hospitalController, const Icon(Icons.local_hospital)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _updateDoctorDetails,
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
          border: Border.all(color: Colors.black, width: 1.0),
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
