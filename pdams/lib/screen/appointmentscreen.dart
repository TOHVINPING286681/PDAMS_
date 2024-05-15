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
import 'historyscreen.dart';
import 'reschedulepatientappointmentscreen.dart';
import 'reschedulepersonalappointmentscreen.dart';

class AppointmentPage extends StatefulWidget {
  final Doctor user;
  const AppointmentPage({super.key, required this.user});

  @override
  State<AppointmentPage> createState() => _AppointmentScreenState();
}

enum FilterStatus { Upcoming, Complete, Cancel }

class _AppointmentScreenState extends State<AppointmentPage> {
  int numberofresult = 0;
  List<Appointment> appointment = <Appointment>[];
  @override
  void initState() {
    super.initState();
    changeStatus();
    loadAppointment();
  }

  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "PDAMs",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue[300],
        ),
        backgroundColor: const Color.fromARGB(255, 218, 249, 254),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(251, 115, 247, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Appointment Schedule',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Config.spaceSmall,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upcoming Appointment',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryScreen(
                                        user: widget.user,
                                      )),
                            );
                          },
                          child: const Text(
                            'History',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                if (appointment.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No Upcoming Appointment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: appointment.map((Appointment app) {
                      if (app.type!.toString() == 'Personal') {
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                            app.appointmentName.toString(),
                                            style: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        app.type.toString(),
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
                                      date: app.date.toString(),
                                      time: app.time.toString()),
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
                                            _cancel(app);
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
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
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReschedulePersonalAppointmentScreen(
                                                  user: widget.user,
                                                  app: app,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Reschedule',
                                            style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
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
                      } else {
                        return Card(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: app.type == 'Government Doctor'
                                  ? Colors.deepPurple
                                  : Colors.red[700],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        // CircleAvatar(
                                        //   backgroundImage: AssetImage(
                                        //       'assets/images/mpp photo 2.png'),
                                        // ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            if (app.type == 'Clinic Doctor')
                                              Text(
                                                'Dr ${app.name}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                            if (app.type == 'Clinic Doctor')
                                              SizedBox(height: 2),
                                            if (app.type == 'Clinic Doctor')
                                              Text(
                                                'Patient: ${app.patientName}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                            SizedBox(height: 2),
                                            Text(
                                              '${app.appointmentName}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: <Widget>[
                                            Text(
                                              '${app.type}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Config.spaceSmall,
                                    ScheduleCard(
                                        date: app.date.toString(),
                                        time: app.time.toString()),
                                    Config.spaceSmall,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ),
                                            onPressed: () {
                                              _cancel(app);
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 5, 5, 5)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        if (app.type == 'Clinic Doctor')
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReschedulePatientAppointmentScreen(
                                                      user: widget.user,
                                                      app: app,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                "Reschedule",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        if (app.type == 'Government Doctor')
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              onPressed: () {
                                                _complete(app);
                                              },
                                              child: const Text(
                                                "Complete",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }).toList(),
                  ),
              ],
            ),
          ),
        ));
  }
  
//real device
  void _complete(Appointment app) {
    http.post(
      Uri.parse(
          "https://vppdams.000webhostapp.com/update_appointment_status.php"),
      body: {
        "id": app.id,
        "state": "Complete",
      },
    ).then((response) {
      if (mounted) {
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
              fontSize: 16.0,
            );
            appointment.clear();
            loadAppointment();
          } else {
            Fluttertoast.showToast(
              msg: "Failed to update appointment status",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Failed to connect to the server",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        }
      }
    });
  }

  void _cancel(Appointment app) {
    http.post(
      Uri.parse(
          "https://vppdams.000webhostapp.com/update_appointment_status.php"),
      body: {
        "id": app.id,
        "state": "Cancel",
      },
    ).then((response) {
      if (mounted) {
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
              fontSize: 16.0,
            );
            appointment.clear();
            loadAppointment();
          } else {
            Fluttertoast.showToast(
              msg: "Failed to update appointment status",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Failed to connect to the server",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0,
          );
        }
      }
    });
  }

// // emulator ok
//   void _complete(Appointment app) {
//     http.post(Uri.parse(
//             "${MyConfig().SERVER}/pdams/php/update_appointment_status.php"),
//             // "https://vppdams.000webhostapp.com/update_appointment_status.php"),
//         body: {
//           "id": app.id,
//           "state": "Complete",
//         }).then((response) {
//       print(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == "success") {
//           setState(() {
//             app.state = "Complete";
//           });
//           Fluttertoast.showToast(
//               msg: "Appointment marked as complete",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               fontSize: 16.0);
//           appointment.clear();
//           loadAppointment();
//         } else {
//           Fluttertoast.showToast(
//               msg: "Failed to update appointment status",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               fontSize: 16.0);
//         }
//       } else {
//         Fluttertoast.showToast(
//             msg: "Failed to connect to the server",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             fontSize: 16.0);
//       }
//     });
//   }

//   void _cancel(Appointment app) {
//     http.post(Uri.parse(
//             "${MyConfig().SERVER}/pdams/php/update_appointment_status.php"),
//             // "https://vppdams.000webhostapp.com/update_appointment_status.php"),
//         body: {
//           "id": app.id,
//           "state": "Cancel",
//         }).then((response) {
//       print(response.body);
//       if (response.statusCode == 200) {
//         var jsondata = jsonDecode(response.body);
//         if (jsondata['status'] == "success") {
//           setState(() {
//             app.state = "Cancel";
//           });
//           Fluttertoast.showToast(
//               msg: "Appointment marked as cancel",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               fontSize: 16.0);
//           appointment.clear();
//           loadAppointment();
//         } else {
//           Fluttertoast.showToast(
//               msg: "Failed to update appointment status",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               fontSize: 16.0);
//         }
//       } else {
//         Fluttertoast.showToast(
//             msg: "Failed to connect to the server",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.BOTTOM,
//             timeInSecForIosWeb: 1,
//             fontSize: 16.0);
//       }
//     });
//   }

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

  void filterAppointmentsByStatus() {
    List<Appointment> upcomingAppointments = appointment.where((appointment) {
      return appointment.status == 'Upcoming' && appointment.state != 'Cancel';
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
