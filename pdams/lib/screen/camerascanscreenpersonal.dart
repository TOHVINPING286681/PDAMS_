import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../myconfig.dart';
import '../model/doctor.dart';
import 'controlscreen.dart';
import 'successbook.dart';

class CameraScanScreenPersonal extends StatefulWidget {
  final Doctor user;

  const CameraScanScreenPersonal({Key? key, required this.user})
      : super(key: key);

  @override
  _CameraScanScreenState createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends State<CameraScanScreenPersonal> {
  File? _imageFile;
  Map<String, dynamic> _scannedData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageFile != null)
                Container(
                  width: 640,
                  height: 480,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                )
              else
                Container(
                  width: 640,
                  height: 480,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(width: 8, color: Colors.black12),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Text(
                    'No Image Selected',
                    style: TextStyle(fontSize: 26),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera),
                    child: const Text("Capture Image",
                        style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.gallery),
                    child: const Text("Select Image",
                        style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_scannedData.isNotEmpty)
                Column(
                  children: [
                    _buildScannedText('Date', _scannedData['Date']),
                    _buildScannedText('Time', _scannedData['Time']),
                    _buildScannedText(
                        'Appointment Name', _scannedData['AppointmentName']),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  if (_imageFile != null) {
                    _performOCR();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select an image first")),
                    );
                  }
                },
                child:
                    const Text("Extract Text", style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_imageFile != null) {
                    _makePersonalAppointment();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please select an image first")),
                    );
                  }
                },
                child: const Text("Add Appointment",
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _imageFile = imageFile;
        _scannedData = {}; // Reset scanned data when a new image is selected
      });
    }
  }

  Future<void> _performOCR() async {
    if (_imageFile == null) return;

    try {
      String apiKey = 'a5a16e7e-0135-11ef-8501-16ad9e3ae21c';
      String modelId = '757f604d-24d9-4213-9e89-d22a42d037be'; //personal

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://app.nanonets.com/api/v2/OCR/Model/$modelId/LabelFile/'),
      );

      request.headers.addAll({
        HttpHeaders.authorizationHeader:
            'Basic ' + base64Encode(utf8.encode('$apiKey:')),
      });

      request.files
          .add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var predictions = jsonResponse['result'][0]['prediction'];

        // Extract relevant fields from predictions
        for (var prediction in predictions) {
          _scannedData[prediction['label']] = prediction['ocr_text'];
        }

        setState(() {});
      } else {
        throw Exception('Failed to perform OCR: HTTP ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error extracting text. Please provide a clear image"),
        ),
      );
      // Reset scanned data in case of failure
      setState(() {
        _scannedData = {};
      });
    }
  }

  Widget _buildScannedText(String label, String? text) {
    try {
      String formattedText =
          text ?? 'Failed to extract the text, please provide a clear image';
      if (label == 'Time' && formattedText.isNotEmpty) {
        // Split the time string to separate hours and minutes
        List<String> timeParts = formattedText.split(RegExp(r'[^0-9]'));
        int hours = int.parse(timeParts[0]);
        // Check if it's PM and not equal to 12, then add 12 hours
        if (formattedText.toLowerCase().contains('pm') && hours != 12) {
          hours += 12;
        }
        // Format the time to HH:mm
        formattedText =
            '${hours.toString().padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}';
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '$label: $formattedText',
          style: TextStyle(fontSize: 18),
        ),
      );
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '$label: Failed to extract the ' +
              '$label' +
              ', please provide a clear image',
          style: TextStyle(fontSize: 18),
        ),
      );
    }
  }

  void _makePersonalAppointment() {
    String? icNumber = widget.user.icNumber;
    String? name = widget.user.name;
    String? appointmentName = _scannedData['AppointmentName'];
    String? date = _scannedData['Date'];
    String? timeString = _scannedData['Time'];

    // Convert time from 12-hour format to 24-hour format
    String time = _convertTo24HourFormat(timeString);
    print(_scannedData['Time']);
    String? type = "Personal";

    http.post(
      Uri.parse("https://vppdams.000webhostapp.com/check_availability.php"),
      // "${MyConfig().SERVER}/pdams/php/check_availability.php"),
      body: {
        'icNumber': icNumber,
        'date': date,
        'time': time,
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['available'] == true) {
          _addAppointment(icNumber, name, appointmentName, date, time, type);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Selected time slot is not available. Please choose another time."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Failed to check availability. Please try again later."),
          ),
        );
      }
    });
  }

  String _convertTo24HourFormat(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '';

    // Split the time string into hours, minutes, and suffix (if any)
    List<String> parts = timeString.split(RegExp(r'[^0-9]'));
    String time = parts[0]; // Extract time part (e.g., "7am")

    // Parse the hours and minutes
    int hours = int.parse(time);
    String minutes = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';

    // If it's PM and not equal to 12, add 12 hours to convert to the 24-hour format
    if (timeString.toLowerCase().contains('pm') && hours != 12) {
      hours += 12;
    }

    // Format the time to HH:mm:ss
    String formattedTime = '${hours.toString().padLeft(2, '0')}:$minutes:00';
    return formattedTime;
  }

  void _addAppointment(String? icNumber, String? name, String? appointmentName,
      String? date, String? time, String? type) {
    http.post(
      Uri.parse(
          "https://vppdams.000webhostapp.com/add_personal_appointment.php"),
      // "${MyConfig().SERVER}/pdams/php/add_personal_appointment.php"),
      body: {
        'icNumber': icNumber,
        'name': name,
        'appointmentName': appointmentName,
        'date': date,
        'time': time,
        'type': type,
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          // If appointment added successfully, navigate to success screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessBookScreen(user: widget.user)),
          );
        } else {
          // Handle failed appointment addition
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Appointment booking failed. Please try again later.")),
          );
        }
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Failed to add appointment. Please try again later.")),
        );
      }
    });
  }
}

//{"message":"Success","result":[{"message":"Success","input":"photo_2024-04-23_15-33-25.jpg","prediction":[{"id":"60ef6cdf-67d4-4c06-b175-bf4076b7d4ad","label":"ICNumber","xmin":359,"ymin":317,"xmax":590,"ymax":352,"score":0,"ocr_text":"011123010369","type":"field","status":"correctly_predicted","page_no":0,"label_id":"5d8b6ac9-54fa-42bf-9258-5f36c828f84a"},{"id":"4a1830ef-a461-4746-b67e-267d2f17e84f","label":"NAME","xmin":340,"ymin":263,"xmax":574,"ymax":294,"score":0,"ocr_text":"Tan Guan Xun","type":"field","status":"correctly_predicted","page_no":0,"label_id":"4934fdf4-83dc-4db5-a78e-201aad0e75ee"},{"id":"07df7f35-f24e-4326-bf9c-ba5aa5e27ce5","label":"Remarks","xmin":0,"ymin":0,"xmax":0,"ymax":0,"score":0,"ocr_text":"['Bone', 'Neck']","type":"field","status":"correctly_predicted","page_no":0,"label_id":"9d9f05c8-a8bc-4233-bbeb-1064279eab67"},{"id":"1a85dc71-50fe-4aca-9ba6-cb1d378bcdf8","label":"Time","xmin":0,"ymin":0,"xmax":0,"ymax":0,"score":0,"ocr_text":"['1600', '1600']","type":"field","status":"correc
