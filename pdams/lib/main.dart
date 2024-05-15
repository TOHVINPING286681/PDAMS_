//import 'package:barterit/color_schemes.g.dart';
import 'package:pdams/screen/controlscreen.dart';
import 'package:pdams/screen/homepage.dart';
import 'package:pdams/screen/loginscreen.dart';
import 'package:pdams/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:pdams/screen/controlscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PDAMs',
      home: SplashScreen(),
      // home: ControlScreen(),
    );
  }
}
