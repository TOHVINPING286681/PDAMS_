import 'package:pdams/screen/appointmentscreen.dart';
import 'package:pdams/screen/profilescreen.dart';
import 'package:pdams/screen/loginscreen.dart';
import 'package:pdams/screen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:pdams/model/doctor.dart';

class ControlScreen extends StatefulWidget {
  final Doctor user;
  const ControlScreen({super.key, required this.user});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  // late List tabchildren;
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("Home");
    tabchildren = [
      HomePage(
        user: widget.user,
      ),
      AppointmentPage(user: widget.user),
      // LoginScreen(/*user: widget.user*/),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month_outlined,
                ),
                label: "Appointment"),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.door_front_door,
            //     ),
            //     label: "Login"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "BookAppointmentPage";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
