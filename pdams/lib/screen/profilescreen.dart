import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdams/screen/controlscreen.dart';
import 'package:pdams/screen/loginscreen.dart';
import 'package:pdams/screen/addmedicinerecord.dart';
import 'package:pdams/screen/editprofilescreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/doctor.dart';
import '../myconfig.dart';
import 'medicinerecord.dart';

class ProfileScreen extends StatefulWidget {
  final Doctor user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Random random = Random();
  var val = 50;
  File? _image;
  @override
  Widget build(BuildContext context) {
    late Doctor user = Doctor(
      id: "na",
      email: "na",
      name: "na",
      password: "na",
      icNumber: "na",
      bloodType: "na",
      doctorID: "na",
      gender: "na",
      medicine: "na",
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PDAMs",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[300],
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 218, 249, 254),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Align(
            //   alignment: Alignment.center,
            //   child: _buildMedicineRecordButton(),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // const Align(
            //   alignment: Alignment.center,
            //   child: CircleAvatar(
            //     radius: 70,
            //     backgroundImage: AssetImage(
            //       'assets/images/mpp photo 2.png',
            //     ),
            //     //need to change to can access profile image
            //   ),
            // ),

            GestureDetector(
              onTap: () {
                _updateImageDialog();
              },
              child: CircleAvatar(
                radius: 70,
                child: ClipOval(
                  child: FutureBuilder<http.Response>(
                    future: http.get(Uri.parse(
                        "https://vppdams.000webhostapp.com/assets/profileimages/${widget.user.icNumber}.png?v=$val")),
                    // "${MyConfig().SERVER}/pdams/assets/profileimages/${widget.user.icNumber}.png?v=$val")),

                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Loading state
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError ||
                          snapshot.data?.statusCode == 404) {
                        // Error or file not found, display placeholder image
                        return Image.asset(
                          'assets/profileimages/na.png',
                          fit: BoxFit.cover,
                        );
                      } else {
                        // Image found, display it
                        return Image.network(
                          "https://vppdams.000webhostapp.com/assets/profileimages/${widget.user.icNumber}.png?v=$val",
                          // "${MyConfig().SERVER}/pdams/assets/profileimages/${widget.user.icNumber}.png?v=$val",

                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            _buildInfoRow('Username', widget.user.name),
            _buildInfoRow('Blood Type', widget.user.bloodType),
            _buildInfoRow('Email', widget.user.email),
            _buildInfoRow('Gender', widget.user.gender),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, value) {
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
            child: Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                                user: widget.user,
                              )),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineRecordButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MedicineRecordScreen(user: widget.user)),
              );
            },
            child: Text(
              'Medicine Record',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              elevation: MaterialStateProperty.all(8.0),
              overlayColor: MaterialStateProperty.all(Colors.blue[700]),
            ),
          ),
        ],
      ),
    );
  }

  _updateImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select from",
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          _galleryPicker(),
                        },
                    icon: const Icon(Icons.browse_gallery),
                    label: const Text("Gallery")),
                TextButton.icon(
                    onPressed: () =>
                        {Navigator.of(context).pop(), _cameraPicker()},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera")),
              ],
            ));
      },
    );
  }

  _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage(_image);
    }
  }

  void _updateProfileImage(image) {
    String base64Image = base64Encode(image!.readAsBytesSync());

    http.post(Uri.parse(
      "https://vppdams.000webhostapp.com/update_image.php"),
        // "${MyConfig().SERVER}/pdams/php/update_image.php"),

        body: {
          "icNumber": widget.user.icNumber,
          "image": base64Image,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        val = random.nextInt(1000);
        setState(() {});
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ControlScreen(
        //             user: widget.user,
        //           )),
        // );
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
