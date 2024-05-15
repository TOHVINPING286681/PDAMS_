import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdams/screen/controlscreen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../model/button.dart';
import '../model/doctor.dart';
import '../myconfig.dart';
import 'camerascanscreen.dart';
import 'successbook.dart';

class BookPatientAppointmentScreen extends StatefulWidget {
  final Doctor user;
  const BookPatientAppointmentScreen({super.key, required this.user});
  // const BookPatientAppointmentScreen({super.key});

  @override
  State<BookPatientAppointmentScreen> createState() =>
      _BookPatientAppointmentScreenState();
}

class _BookPatientAppointmentScreenState
    extends State<BookPatientAppointmentScreen> {
  final TextEditingController _appointmentNameEditingController =
      TextEditingController();
  final TextEditingController _patientICEditingController =
      TextEditingController();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _isWeekend = false;
  bool _dateSelected = false;
  bool _timeSelected = false;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
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
                    builder: (context) => ControlScreen(user: widget.user)));
          },
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.blue[50],
            title: Container(
              height: 50,
              child: TextFormField(
                controller: _patientICEditingController,
                decoration: InputDecoration(
                  hintText: 'Please Key in the patient Ic Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            centerTitle: true,
            expandedHeight: 10,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                _tableCalendar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                  child: Center(
                    child: Text(
                      "Select The Booking Time",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
          _isWeekend
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
                    alignment: Alignment.center,
                    child: const Text(
                      'Weekend is not available, please choose another date',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                )
              : SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            _currentIndex = index;
                            _timeSelected = true;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: _currentIndex == index
                                ? Config.primaryColor
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 9}:00 ${index + 9 > 11 ? "PM" : "AM"}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  _currentIndex == index ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.5),
                ),
          SliverToBoxAdapter(
            child: Form(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _appointmentNameEditingController,
                      decoration: InputDecoration(
                        hintText: 'Appointment Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the appointment title';
                        }
                        return null;
                      },
                    ),
                    Button(
                      width: double.infinity,
                      title: 'Make Appointment',
                      onPressed: () {
                        _makePatientAppointment();
                      },
                      disable: _timeSelected && _dateSelected ? false : true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCalendar() {
    return TableCalendar(
        focusedDay: _focusDay,
        firstDay: DateTime.now(),
        lastDay: DateTime(2030, 12, 31),
        calendarFormat: _format,
        currentDay: _currentDay,
        rowHeight: 48,
        calendarStyle: const CalendarStyle(
          todayDecoration:
              BoxDecoration(color: Config.primaryColor, shape: BoxShape.circle),
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
        },
        onFormatChanged: (format) {
          setState(() {
            _format = format;
          });
        },
        onDaySelected: ((selectedDay, focusedDay) {
          setState(() {
            _currentDay = selectedDay;
            _focusDay = focusedDay;
            _dateSelected = true;

            //check if weekend is selected
            if (selectedDay.weekday == 6 || selectedDay.weekday == 7) {
              _isWeekend = true;
              _timeSelected = false;
              _currentIndex = null;
            } else {
              _isWeekend = false;
            }
          });
        }));
  }

  void _makePatientAppointment() {
    _currentIndex = (_currentIndex! + 9);
    String? icNumber = widget.user.icNumber;
    String? name = widget.user.name;
    String? patientICNumber = _patientICEditingController.text;
    String? appointmentName = _appointmentNameEditingController.text;
    String? date = _currentDay.toString().split(' ')[0];
    String? time = _currentIndex.toString() + ":00";
    String? type = _getTypeFromDoctorID(widget.user.doctorID);

    if (patientICNumber == widget.user.icNumber) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cannot enter your own IC Number."),
        ),
      );
    } else {
      _fetchPatientName(patientICNumber!).then((patientName) {
        if (patientName != null) {
          http.post(
            Uri.parse(
                "https://vppdams.000webhostapp.com/check_availability.php"),
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
                http.post(
                  Uri.parse(
                      "https://vppdams.000webhostapp.com/check_availability.php"),
                      // "${MyConfig().SERVER}/pdams/php/check_availability.php"),
                  body: {
                    'icNumber': patientICNumber,
                    'date': date,
                    'time': time,
                  },
                ).then((response) {
                  print(response.body);
                  if (response.statusCode == 200) {
                    var jsonData = jsonDecode(response.body);
                    if (jsonData['available'] == true) {
                      http.post(
                        Uri.parse(
                            "https://vppdams.000webhostapp.com/add_patient_appointment.php"),
                            // "${MyConfig().SERVER}/pdams/php/add_patient_appointment.php"),
                        body: {
                          'icNumber': icNumber,
                          'name': name,
                          'patientName': patientName,
                          'patientICNumber': patientICNumber,
                          'appointmentName': appointmentName,
                          'date': date,
                          'time': time,
                          'type': type
                        },
                      ).then((response) {
                        print(response.body);
                        if (response.statusCode == 200) {
                          var jsondata = jsonDecode(response.body);
                          print(response.body);
                          if (jsondata['status'] == 'success') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SuccessBookScreen(user: widget.user)),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Add Failed")));
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Add Failed")));
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Selected time slot is not available. Please choose another time."),
                        ),
                      );
                    }
                  } else {
                    // Handle server error
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Failed to check availability. Please try again later."),
                      ),
                    );
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Selected time slot is not available. Please choose another time."),
                  ),
                );
              }
            } else {
              // Handle server error
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Failed to check availability. Please try again later."),
                ),
              );
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  "Failed to fetch patient IC Number. Check patient IC Number again.")));
        }
      });
    }
  }

  Future<String?> _fetchPatientName(String patientICNumber) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://vppdams.000webhostapp.com/fetch_patient_name.php"),
            // "${MyConfig().SERVER}/pdams/php/fetch_patient_name.php"),
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

  String _getTypeFromDoctorID(String? doctorID) {
    if (doctorID != null) {
      if (doctorID.toLowerCase().contains('c')) {
        return 'Clinic Doctor';
      } else if (doctorID.toLowerCase().contains('g')) {
        return 'Government Doctor';
      }
    }
    return 'Personal';
  }
}
