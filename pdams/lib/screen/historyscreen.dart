import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdams/config.dart';
import 'package:pdams/model/doctor.dart';
import 'package:pdams/screen/bookpatientappointment.dart';
import 'package:pdams/screen/bookpersonalappointment.dart';
import 'package:http/http.dart' as http;
import '../model/appointment.dart';
import '../myconfig.dart';
import 'controlscreen.dart';
import 'reschedulepersonalappointmentscreen.dart';

class HistoryScreen extends StatefulWidget {
  final Doctor user;
  const HistoryScreen({super.key, required this.user});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

enum FilterStatus { Inprogress, Complete, Cancel }

class _HistoryScreenState extends State<HistoryScreen> {
  int numberofresult = 0;
  List<Appointment> appointment = <Appointment>[];
  @override
  void initState() {
    super.initState();
    changeStatus();
    loadAppointment();
  }

  FilterStatus status = FilterStatus.Inprogress;
  Alignment _alignment = Alignment.centerLeft;
  @override
  Widget build(BuildContext context) {
    List<dynamic> appointments = appointment.where((schedule) {
      switch (status) {
        case FilterStatus.Inprogress:
          return schedule.state == 'Inprogress';
        case FilterStatus.Complete:
          return schedule.state == 'Complete';
        case FilterStatus.Cancel:
          return schedule.state == 'Cancel';
        default:
          return false;
      }
    }).toList();

    return SafeArea(
      child: Scaffold(
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
        backgroundColor: const Color.fromARGB(255, 218, 249, 254),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Past Appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Config.spaceSmall,
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (FilterStatus filterStatus
                                in FilterStatus.values)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (filterStatus ==
                                          FilterStatus.Inprogress) {
                                        status = FilterStatus.Inprogress;
                                        _alignment = Alignment.centerLeft;
                                      } else if (filterStatus ==
                                          FilterStatus.Complete) {
                                        status = FilterStatus.Complete;
                                        _alignment = Alignment.center;
                                      } else if (filterStatus ==
                                          FilterStatus.Cancel) {
                                        status = FilterStatus.Cancel;
                                        _alignment = Alignment.centerRight;
                                      }
                                    });
                                  },
                                  child: Center(
                                    child: Text(filterStatus.name),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                      AnimatedAlign(
                        alignment: _alignment,
                        duration: const Duration(milliseconds: 150),
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Config.primaryColor,
                            borderRadius: BorderRadiusDirectional.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              status.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Config.spaceSmall,
                  Column(children: [
                    if (appointments.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No Record',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else
                      ...appointments.map((schedule) {
                        if (schedule.type!.toString() == 'Personal' &&
                            schedule.state!.toString() == 'Inprogress') {
                          return Card(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(226, 252, 147, 0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Config.spaceSmall,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule.appointmentName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          schedule.type.toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ScheduleCard(
                                      date: schedule.date.toString(),
                                      time: schedule.time.toString(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              _cancel(schedule);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Config.primaryColor,
                                            ),
                                            onPressed: () {
                                              _complete(schedule);
                                            },
                                            child: const Text(
                                              'Complete',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (schedule.type!.toString() == 'Personal' &&
                            (schedule.state!.toString() == 'Complete' ||
                                schedule.state!.toString() == 'Cancel')) {
                          return Card(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(226, 252, 147, 0),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Config.spaceSmall,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule.appointmentName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          schedule.type.toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ScheduleCard(
                                      date: schedule.date.toString(),
                                      time: schedule.time.toString(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (schedule.type!.toString() ==
                                'Government Doctor' &&
                            schedule.state!.toString() == 'Inprogress') {
                          return Card(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Config.spaceSmall,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule.appointmentName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          schedule.type.toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ScheduleCard(
                                      date: schedule.date.toString(),
                                      time: schedule.time.toString(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              _cancel(schedule);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Config.primaryColor,
                                            ),
                                            onPressed: () {
                                              _complete(schedule);
                                            },
                                            child: const Text(
                                              'Complete',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (schedule.type!.toString() ==
                                'Government Doctor' &&
                            (schedule.state!.toString() == 'Complete' ||
                                schedule.state!.toString() == 'Cancel')) {
                          return Card(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Config.spaceSmall,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule.appointmentName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          schedule.type.toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ScheduleCard(
                                      date: schedule.date.toString(),
                                      time: schedule.time.toString(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (schedule.type!.toString() ==
                                'Clinic Doctor' &&
                            schedule.state!.toString() == 'Inprogress') {
                          return Card(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Config.spaceSmall,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule.appointmentName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          schedule.type.toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ScheduleCard(
                                      date: schedule.date.toString(),
                                      time: schedule.time.toString(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              _cancel(schedule);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                                  Config.primaryColor,
                                            ),
                                            onPressed: () {
                                              _complete(schedule);
                                            },
                                            child: const Text(
                                              'Complete',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else if (schedule.type!.toString() ==
                                'Clinic Doctor' &&
                            (schedule.state!.toString() == 'Complete' ||
                                schedule.state!.toString() == 'Cancel')) {
                          return Card(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.red[700],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        Config.spaceSmall,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule.appointmentName
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          schedule.type.toString(),
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    ScheduleCard(
                                      date: schedule.date.toString(),
                                      time: schedule.time.toString(),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Card();
                        }
                      }),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _complete(Appointment app) {
    http.post(
        Uri.parse(
            "https://vppdams.000webhostapp.com/update_appointment_status.php"),
        //  "${MyConfig().SERVER}/pdams/php/update_appointment_status.php"),

        body: {
          "id": app.id,
          "state": "Complete",
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          setState(() {
            app.state = "Complete";
          });
          Fluttertoast.showToast(
              msg: "Appointment marked as complete",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          loadAppointment();
        } else {
          Fluttertoast.showToast(
              msg: "Failed to update appointment status",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to connect to the server",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void _cancel(Appointment app) {
    http.post(
        Uri.parse(
            "https://vppdams.000webhostapp.com/update_appointment_status.php"),
        // "${MyConfig().SERVER}/pdams/php/update_appointment_status.php"),

        body: {
          "id": app.id,
          "state": "Cancel",
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          setState(() {
            app.state = "Cancel";
          });
          Fluttertoast.showToast(
              msg: "Appointment marked as cancel",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
          loadAppointment();
        } else {
          Fluttertoast.showToast(
              msg: "Failed to update appointment status",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Failed to connect to the server",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }

  void changeStatus() {
    String date = DateTime.now().toString().split(' ')[0];
    http.post(Uri.parse("https://vppdams.000webhostapp.com/change_status.php"),
        // "${MyConfig().SERVER}/pdams/php/change_status.php"),

        body: {
          "date": date,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {}
      }
    });
  }

void loadAppointment() {
  http.post(
    Uri.parse("https://vppdams.000webhostapp.com/load_appointment.php"),
    body: {
      "icNumber": widget.user.icNumber,
      "date": DateTime.now().toString(),
    },
  ).then((response) {
    print(response.body);
    appointment.clear();
    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        numberofresult = int.parse(jsondata['numberofresult']);
        print(numberofresult);
        var extractdata = jsondata['data'];
        var appointmentsData = extractdata['appointments'];

        appointmentsData.forEach((v) {
          appointment.add(Appointment.fromJson(v));
        });

        // Sort the appointments by date and time
        appointment.sort((a, b) {
          var dateComparison = a.date!.compareTo(b.date!);
          if (dateComparison != 0) {
            return dateComparison;
          } else {
            return a.time!.compareTo(b.time!);
          }
        });

        filterAppointmentsByStatus();
      }
      setState(() {});
    }
  });
}


  void filterAppointmentsByStatus() {
    List<Appointment> upcomingAppointments = appointment.where((appointment) {
      return appointment.status == 'Past' ||
          appointment.state == 'Cancel' ||
          appointment.state == 'Complete';
    }).toList();

    setState(() {
      appointment = upcomingAppointments;
    });
  }
}

class ScheduleCard extends StatelessWidget {
  final String date;
  final String time;

  const ScheduleCard({Key? key, required this.date, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 15,
          ),
          SizedBox(width: 5),
          Text(
            date,
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(width: 20),
          Icon(
            Icons.access_alarm_rounded,
            color: const Color.fromARGB(255, 0, 0, 0),
            size: 17,
          ),
          SizedBox(width: 5),
          Text(
            time,
            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
    );
  }
}
