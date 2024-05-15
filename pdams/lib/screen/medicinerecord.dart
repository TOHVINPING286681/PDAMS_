import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdams/screen/controlscreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../model/button.dart';
import '../model/doctor.dart';
import '../model/medicine.dart';
import '../myconfig.dart';
import 'addmedicinerecord.dart';
import 'homepage.dart';
import 'successbook.dart';

class MedicineRecordScreen extends StatefulWidget {
  final Doctor user;
  const MedicineRecordScreen({super.key, required this.user});

  @override
  State<MedicineRecordScreen> createState() => _MedicineRecordScreenState();
}

class _MedicineRecordScreenState extends State<MedicineRecordScreen> {
  int numberofresult = 0;
  List<Medicine> medicine = <Medicine>[];
  @override
  void initState() {
    super.initState();
    loadMedicine();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

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
      backgroundColor: const Color.fromARGB(255, 218, 249, 254),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Medicine Record',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (medicine.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Medicine Record',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: medicine.map((Medicine medi) {
                    if (medi.type!.toString() == 'Government Doctor') {
                      return Card(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Date: ${medi.date}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              Text(
                                                'Time: ${medi.time}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Medicine Name: ${medi.medicinename}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              Text(
                                                'Take ${medi.tabletsCapsules} tablet ${medi.timesPerDay} times Daily ${medi.food}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              Text(
                                                '${medi.timing}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text(
                                        '${medi.type}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      // Text(
                                      //   '${medi.doctorID}',
                                      //   style: TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w600,
                                      //     color: const Color.fromARGB(
                                      //         255, 255, 255, 255),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Card(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red[700],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Dr ${medi.name}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Date: ${medi.date}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              Text(
                                                'Time: ${medi.time}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                              Text(
                                                'Medicine Name: ${medi.medicinename}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              Text(
                                                'Take ${medi.tabletsCapsules} tablet ${medi.timesPerDay} times Daily ${medi.food}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              Text(
                                                '${medi.timing}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ),
                                              ),
                                              SizedBox(height: 2),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text(
                                        '${medi.type}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                      Text(
                                        '${medi.doctorID}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void loadMedicine() {
    http.post(Uri.parse("https://vppdams.000webhostapp.com/load_medicine.php"),
        // "${MyConfig().SERVER}/pdams/php/load_medicine.php"),
        body: {
          "icNumber": widget.user.icNumber,
        }).then((response) {
      print(response.body);

      medicine.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          var medicinesData = extractdata['medicines'];

          medicinesData.forEach((v) {
            medicine.add(Medicine.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }
}
