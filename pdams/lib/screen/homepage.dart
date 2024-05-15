// ignore_for_file: unnecessary_const

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:pdams/model/appointment.dart';
import 'package:pdams/model/doctor.dart';
import 'package:http/http.dart' as http;
import 'package:pdams/screen/addmedicinerecord.dart';
import 'package:pdams/screen/bookgovernmentappointment.dart';
import 'package:pdams/screen/camerascanscreen.dart';
import 'package:pdams/screen/addgovernmentmedicine.dart';
import '../config.dart';
import '../myconfig.dart';
import 'bookpatientappointment.dart';
import 'bookpersonalappointment.dart';
import 'camerascanscreenpersonal.dart';
import 'loginscreen.dart';
import 'medicinerecord.dart';

class HomePage extends StatefulWidget {
  final Doctor user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var val = 50;
  int numberofresult = 0;
  List<Appointment> appointment = <Appointment>[];
  @override
  void initState() {
    super.initState();
    loadAppointment();
    changeStatus();
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
      ),
      backgroundColor: const Color.fromARGB(255, 218, 249, 254),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.user.name.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: FutureBuilder<http.Response>(
                          future: http.get(Uri.parse(
                              "https://vppdams.000webhostapp.com/assets/profileimages/${widget.user.icNumber}.png?v=$val")),
                          // "${MyConfig().SERVER}/pdams/assets/profileimages/${widget.user.icNumber}.png?v=$val")),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                  )
                ],
              ),
              Config.spaceSmall,
              const Text(
                'Appointment Today',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Config.spaceSmall,
              if (appointment.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'No Appointment Today',
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
                                            color: Color.fromARGB(255, 0, 0, 0),
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
                                            color: Color.fromARGB(255, 0, 0, 0),
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
                                          backgroundColor: Config.primaryColor,
                                        ),
                                        onPressed: () {
                                          _complete(app);
                                        },
                                        child: const Text(
                                          'Complete',
                                          style: TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
              Config.spaceSmall,
              const Text(
                'Book Your Appointment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookPersonalAppointmentScreen(
                                  user: widget.user,
                                )),
                      );
                    },
                    child: const Text(
                      'Personal Appointment',
                      style: TextStyle(fontSize: 15),
                      overflow:
                          TextOverflow.ellipsis, // Ensure text doesn't overflow
                      maxLines: 1, // Limit text to a single line
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize:
                          Size(2000, 20), // Adjust the minimum size as needed
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookGovernmentAppointment(
                                  user: widget.user,
                                )),
                      );
                    },
                    child: const Text(
                      'Government Appointment',
                      style: TextStyle(fontSize: 15),
                      overflow:
                          TextOverflow.ellipsis, // Ensure text doesn't overflow
                      maxLines: 1, // Limit text to a single line
                    ),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize:
                          Size(2000, 20), // Adjust the minimum size as needed
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (widget.user.doctorID != null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  BookPatientAppointmentScreen(
                                    user: widget.user,
                                  )),
                        );
                      },
                      child: const Text(
                        'Patient Appointment',
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow
                            .ellipsis, // Ensure text doesn't overflow
                        maxLines: 1, // Limit text to a single line
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minimumSize:
                            Size(2000, 20), // Adjust the minimum size as needed
                      ),
                    ),
                ],
              ),
              Config.spaceSmall,
              if (widget.user.doctorID != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Medicine',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                        'Medicine History',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              if (widget.user.doctorID != null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddMedicineRecordScreen(
                                    user: widget.user,
                                  )),
                        );
                      },
                      child: const Text(
                        ' Add Patient Medicine Record',
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow
                            .ellipsis, // Ensure text doesn't overflow
                        maxLines: 1, // Limit text to a single line
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minimumSize:
                            Size(2000, 20), // Adjust the minimum size as needed
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.user.doctorID != null)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddGovernmentMedicineRecord(
                                      user: widget.user,
                                    )),
                          );
                        },
                        child: const Text(
                          ' Add Government Medicine Record',
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow
                              .ellipsis, // Ensure text doesn't overflow
                          maxLines: 1, // Limit text to a single line
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          minimumSize: Size(
                              2000, 20), // Adjust the minimum size as needed
                        ),
                      ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Medicine',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                        'Medicine History',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              if (widget.user.doctorID == null)
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddGovernmentMedicineRecord(
                                    user: widget.user,
                                  )),
                        );
                      },
                      child: const Text(
                        'Add Government Medicine Record',
                        style: TextStyle(fontSize: 15),
                        overflow: TextOverflow
                            .ellipsis, // Ensure text doesn't overflow
                        maxLines: 1, // Limit text to a single line
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        minimumSize:
                            Size(2000, 20), // Adjust the minimum size as needed
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
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

          filterAppointmentsByTodayDate();
        }
        setState(() {});
      }
    });
  }

  void filterAppointmentsByTodayDate() {
    DateTime today = DateTime.now();
    String? state = 'Inprogress';
    List<Appointment> appointmentsToday = appointment.where((appointment) {
      DateTime appointmentDate = DateTime.parse(appointment.date.toString());
      return appointmentDate.year == today.year &&
          appointmentDate.month == today.month &&
          appointmentDate.day == today.day &&
          appointment.state == state;
    }).toList();

    setState(() {
      appointment = appointmentsToday;
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

  void _complete(Appointment app) {
    http.post(
        Uri.parse(
            "https://vppdams.000webhostapp.com/update_appointment_status.php"),
        // "${MyConfig().SERVER}/pdams/php/update_appointment_status.php"),
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
          appointment.clear();
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
          appointment.clear();
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
