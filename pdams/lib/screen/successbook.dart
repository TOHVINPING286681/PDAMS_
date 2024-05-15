import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pdams/screen/controlscreen.dart';

import '../model/button.dart';
import '../model/doctor.dart';
import 'homepage.dart';

class SuccessBookScreen extends StatefulWidget {
  final Doctor user;
  const SuccessBookScreen({super.key, required this.user});

  @override
  State<SuccessBookScreen> createState() => _SuccessBookScreenState();
}

class _SuccessBookScreenState extends State<SuccessBookScreen> {
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Lottie.asset('assets/success.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'Successfully Booked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Button(
                width: double.infinity,
                title: 'Back to Home Page',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ControlScreen(user: widget.user)),
                  );
                },
                disable: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
