import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:strokecare/uril.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:strokecare/Upper Extremity.dart'; // Import your page here
import 'package:strokecare/dash.dart'; // Import your Dashboard here
import 'doctordetails.dart'; // Import the DoctorDetails page
import 'allpatients.dart';

class RegistrationPage extends StatefulWidget {
  final String doctorId;

  const RegistrationPage({super.key, required this.doctorId});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pidController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  String? _ageError;
  String? _mobileError;
  String? _dateError;

  var maskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();

    // Add listeners to validate fields as the user types
    _ageController.addListener(() {
      setState(() {
        _ageError = _validateAge(_ageController.text);
      });
    });

    _mobileController.addListener(() {
      setState(() {
        _mobileError = _validateMobile(_mobileController.text);
      });
    });

    _dateController.addListener(() {
      setState(() {
        _dateError = _validateDate(_dateController.text);
      });
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _pickImageFromSource(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  _pickImageFromSource(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    }
    final age = int.tryParse(value);
    if (age == null || age < 0 || age > 200) {
      return 'Age must be between 0 and 200';
    }
    return null;
  }

  String? _validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your gender';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length != 10) {
      if (value.length < 10) {
        return 'Number is less than 10 digits';
      } else {
        return 'Number is more than 10 digits';
      }
    }
    return null;
  }

  String? _validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter the date';
  }

  // Check if the input is long enough to extract day, month, and year
  if (value.length < 10) {
    return 'Please enter the complete date (DD-MM-YYYY)';
  }

  try {
    final day = int.tryParse(value.substring(0, 2));
    final month = int.tryParse(value.substring(3, 5));
    final year = int.tryParse(value.substring(6));

    if (day == null || day < 1 || day > 31) {
      return 'Day must be between 01 and 31';
    }
    if (month == null || month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }
    if (year == null || year < 1800 || year > 3000) {
      return 'Year must be between 1800 and 3000';
    }
  } catch (e) {
    return 'Invalid date format';
  }

  return null;
}

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate() && _selectedImage != null) {
    String base64Image = base64Encode(_selectedImage!.readAsBytesSync());
    var url = '${Urils.Url}/signup.php';
    
    Map<String, dynamic> data = {
      "name": _nameController.text,
      "age": _ageController.text,
      "gender": _genderController.text,
      "number": _mobileController.text,
      "pid": _pidController.text,
      "address": _addressController.text,
      "date": _dateController.text,
      "image": base64Image,
      "doctor_id": widget.doctorId,
    };
    
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data), // Encode the data to JSON
      );

      if (response.statusCode == 200) {
        var result = response.body.trim(); // Trim any unnecessary whitespace
        if (result == "patients entry Success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Upper(
                doctorId: widget.doctorId,
                pid: _pidController.text,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $result')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Error')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All fields are required, including the image')),
    );
  }
}
  int _selectedIndex = 2; // Set initial index for Add button

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to All Patients page (you can replace this with your actual page)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllPatients(doctorId: widget.doctorId)),
      );
    } else if (index == 1) {
      // Navigate to Home (Dashboard)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard(doctorId: widget.doctorId)),
      );
    } else if (index == 3) {
      // Navigate to Profile page (replace with your actual page)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DoctorDetails(doctorId: widget.doctorId)),
      );
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
          title: const Text('Registration'),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Center(
                    child: CircleAvatar(
                      radius: 70, // Increased size
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? const Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    prefixIcon: const Icon(Icons.cake),
                    errorText: _ageError,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _genderController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.wc),
                  ),
                  validator: _validateGender,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    prefixIcon: const Icon(Icons.phone),
                    errorText: _mobileError,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _pidController,
                  decoration: const InputDecoration(
                    labelText: 'Patient ID',
                    prefixIcon: Icon(Icons.badge),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: const Icon(Icons.calendar_month),
                    errorText: _dateError,
                  ),
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 30),
                Center( // Center the button
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.lightBlue[200],
                ),
                    child: const Text('Register',style: TextStyle(fontSize: 18, color: Colors.black),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.list_alt, title: 'Patients'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.add_circle, title: 'Add'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
backgroundColor: const Color.fromARGB(255, 0, 200, 255),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF00CDE2),
            Color(0xFF00ADFF),
          ],
        ),      ),
    );
  }
} 