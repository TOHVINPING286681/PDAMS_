import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pdams/screen/successbook.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../model/button.dart';
import '../model/doctor.dart';
import '../myconfig.dart';
import 'camerascanscreen.dart';
import 'camerascanscreenpersonal.dart';
import 'controlscreen.dart';

class BookGovernmentAppointment extends StatefulWidget {
  final Doctor user;
  const BookGovernmentAppointment({super.key, required this.user});

  @override
  State<BookGovernmentAppointment> createState() =>
      _BookGovernmentAppointmentState();
}

class _BookGovernmentAppointmentState extends State<BookGovernmentAppointment> {
  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _appointmentNameEditingController =
      TextEditingController();
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CameraScanScreen(
                            user: widget.user,
                          )));
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
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
          SliverGrid(
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
                      color:
                          _currentIndex == index ? Config.primaryColor : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index}:00 ${index > 11 ? "PM" : "AM"}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _currentIndex == index ? Colors.white : null,
                      ),
                    ),
                  ),
                );
              },
              childCount: 24,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, childAspectRatio: 1.5),
          ),
          SliverToBoxAdapter(
            child: Form(
              // key: _formKey,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                        _makeGovernmentAppointment();
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

  void _makeGovernmentAppointment() {
    String? icNumber = widget.user.icNumber;
    String? name = widget.user.name;
    String? appointmentName = _appointmentNameEditingController.text;
    String? date = _currentDay.toString().split(' ')[0];
    String? time = _currentIndex.toString() + ":00";
    String? type = "Government Doctor";

    http.post(
      Uri.parse(
          // "${MyConfig().SERVER}/pdams/php/check_availability.php"),
          "https://vppdams.000webhostapp.com/check_availability.php"),
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

  void _addAppointment(String? icNumber, String? name, String? appointmentName,
      String? date, String? time, String? type) {
    http.post(
      Uri.parse(
          "https://vppdams.000webhostapp.com/add_government_appointment.php"),
      // "${MyConfig().SERVER}/pdams/php/add_government_appointment.php"),
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
          });
        }));
  }
}
