import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../model/doctor.dart';
import '../myconfig.dart';
import 'controlscreen.dart';
import 'homepage.dart';

List<String> bloodtype = <String>['A', 'B', 'AB', 'O'];
List<String> gender = <String>['Male', 'Female'];

class EditProfileScreen extends StatefulWidget {
  final Doctor user;
  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _userNameController;
  // late TextEditingController _bloodTypeController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
  late TextEditingController _medicineRecordController;
  String? selectedBloodType;
  String? selectedGender;
  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.name);
    // _bloodTypeController = TextEditingController(text: widget.user.bloodType);
    _emailController = TextEditingController(text: widget.user.email);
    _genderController = TextEditingController(text: widget.user.gender);
    selectedBloodType = widget.user.bloodType;
    selectedGender = widget.user.gender;
    _medicineRecordController =
        TextEditingController(text: widget.user.medicine);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDAMs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ControlScreen(user: widget.user),
              ),
            );
          },
        ),
      ),
      backgroundColor: Color.fromARGB(255, 218, 249, 254),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Title(
              color: Colors.black,
              child: Text(
                'Edit your profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            _buildInfoTextField('Username', _userNameController),
            // _buildInfoTextField('Blood Type', _bloodTypeController),
            _buildInfoTextField('Email', _emailController),
            // _buildInfoTextField('Gender', _genderController),
            // _buildInfoTextField('Medicine Record', _medicineRecordController),
            const SizedBox(height: 10),

            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Gender:   ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 143, 230, 244),
                      ),
                      child: DropdownButton<String>(
                        value: selectedGender,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Color.fromARGB(255, 218, 249, 254),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedGender = value.toString();
                          });
                        },
                        items: gender
                            .map<DropdownMenuItem<String>>((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Bloodtype:   ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 143, 230, 244),
                      ),
                      child: DropdownButton<String>(
                        value: selectedBloodType,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Color.fromARGB(255, 218, 249, 254),
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedBloodType = value.toString();
                          });
                        },
                        items: bloodtype
                            .map<DropdownMenuItem<String>>((String bloodtype) {
                          return DropdownMenuItem<String>(
                            value: bloodtype,
                            child: Text(bloodtype),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String name = _userNameController.text;
                String bloodType = selectedBloodType.toString();
                String email = _emailController.text;
                String gender = selectedGender.toString();
                String medicine = _medicineRecordController.text;
                _updateProfile(name, bloodType, email, gender, medicine);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ControlScreen(user: widget.user)),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _updateProfile(String name, String bloodType, String email,
      String gender, String medicine) {
    http.post(Uri.parse("https://vppdams.000webhostapp.com/update_profile.php"),
        // "${MyConfig().SERVER}/pdams/php/update_profile.php"),
        body: {
          "icNumber": widget.user.icNumber,
          "name": name,
          'bloodType': bloodType,
          'email': email,
          'gender': gender,
          'medicine': medicine,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Edit Success")));
        setState(() {
          widget.user.name = name;
          widget.user.email = email;
          widget.user.gender = gender;
          widget.user.bloodType = bloodType;
          widget.user.medicine = medicine;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Edit Fail")));
      }
    });
  }
}
