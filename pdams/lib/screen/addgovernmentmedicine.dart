import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdams/screen/controlscreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../model/button.dart';
import '../model/doctor.dart';
import '../myconfig.dart';
import 'homepage.dart';
import 'successbook.dart';

List<String> tabletsCapsules = <String>['1', '2', '3', '4'];
List<String> timesPerDay = <String>['1', '2', '3'];

String selectedtabletsCapsules = '1';
String selectedtimesPerDay = '1';
String selectedTiming = 'When In Need';
String selectedFood = 'Before Food';

class AddGovernmentMedicineRecord extends StatefulWidget {
  final Doctor user;
  const AddGovernmentMedicineRecord({super.key, required this.user});

  @override
  _MedicineRecordScreenState createState() => _MedicineRecordScreenState();
}

class _MedicineRecordScreenState extends State<AddGovernmentMedicineRecord> {
  final TextEditingController medicinenameController = TextEditingController();

  final TextEditingController _patientICEditingController =
      TextEditingController();

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
                    builder: (context) => ControlScreen(user: widget.user)));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: medicinenameController,
                decoration: InputDecoration(labelText: 'Medicine Name'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Radio(
                      value: "When In Need",
                      groupValue: selectedTiming,
                      onChanged: (value) {
                        setState(() {
                          selectedTiming = value.toString();
                        });
                      }),
                  const Text(
                    'When In Need',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Radio(
                      value: "Finish It",
                      groupValue: selectedTiming,
                      onChanged: (value) {
                        setState(() {
                          selectedTiming = value.toString();
                        });
                      }),
                  const Text(
                    'Finish It',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  Radio(
                      value: "Before Food",
                      groupValue: selectedFood,
                      onChanged: (value) {
                        setState(() {
                          selectedFood = value.toString();
                        });
                      }),
                  const Text(
                    'Before Food',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Radio(
                      value: "After Food",
                      groupValue: selectedFood,
                      onChanged: (value) {
                        setState(() {
                          selectedFood = value.toString();
                        });
                      }),
                  const Text(
                    'After Food',
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Tablets capsules per time:   ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 143, 230, 244),
                    ),
                    child: DropdownButton<String>(
                      value: selectedtabletsCapsules,
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
                          selectedtabletsCapsules = value.toString();
                        });
                      },
                      items: tabletsCapsules.map<DropdownMenuItem<String>>(
                          (String tabletsCapsules) {
                        return DropdownMenuItem<String>(
                          value: tabletsCapsules,
                          child: Text(tabletsCapsules),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    'Times Daily:   ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 143, 230, 244),
                    ),
                    child: DropdownButton<String>(
                      value: selectedtimesPerDay,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Color.fromARGB(255, 218, 249, 254),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          selectedtimesPerDay = value.toString();
                        });
                      },
                      items: timesPerDay
                          .map<DropdownMenuItem<String>>((String timesPerDay) {
                        return DropdownMenuItem<String>(
                          value: timesPerDay,
                          child: Text(timesPerDay),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: addMedicineRecord,
                child: Text('Add Medicine Record'),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  void addMedicineRecord() {
    DateTime dates = DateTime.now();

    DateTime _currentDay = DateTime.now();
    String? medicinename = medicinenameController.text;
    String? timesPerDay = selectedtimesPerDay.toString();
    String? tabletsCapsules = selectedtabletsCapsules.toString();
    String? timing = selectedTiming.toString();
    String? food = selectedFood.toString();
    String? date = _currentDay.toString().split(' ')[0];
    String? time = "${dates.hour}:00";
    String? icNumber = widget.user.icNumber;
    String? name = widget.user.name;
    String? type = 'Government Doctor';

    http.post(
      // Uri.parse("${MyConfig().SERVER}/pdams/php/add_government_medicine.php"),
      Uri.parse("https://vppdams.000webhostapp.com/add_government_medicine.php"),

      body: {
        'name': name,
        'icNumber': icNumber,
        'medicinename': medicinename,
        'timesPerDay': timesPerDay,
        'date': date,
        'time': time,
        'type': type,
        'tabletsCapsules': tabletsCapsules,
        'timing': timing,
        'food': food,
      },
    ).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add Successful."),
            ),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ControlScreen(user: widget.user)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add Failed."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Add Failed."),
          ),
        );
      }
    });
  }

  Future<String?> _fetchPatientName(String patientICNumber) async {
    try {
      final response = await http.post(
        Uri.parse("https://vppdams.000webhostapp.com/fetch_patient_name.php"),
        // Uri.parse("${MyConfig().SERVER}/pdams/php/fetch_patient_name.php"),

        body: {'patientICNumber': patientICNumber},
      );
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          return jsondata['patientName'];
        }
      }
    } catch (e) {
      print("Error fetching patient name: $e");
    }
    return null;
  }
}
