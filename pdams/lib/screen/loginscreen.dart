import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdams/model/clinicDoctor.dart';
import 'package:pdams/model/doctor.dart';
import 'package:pdams/myconfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdams/model/doctor.dart';
import 'package:pdams/screen/homepage.dart';

import '../model/governmentDoctor.dart';
import '../model/normalUser.dart';
import 'controlscreen.dart';

// import 'package:barterit/model/user.dart';
List<String> bloodtype = <String>['A', 'B', 'AB', 'O'];
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late double screenHeight, screenWidth, cardwitdh;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
        backgroundColor: Color.fromARGB(255, 218, 249, 254),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.of(context).size.height * 1,
                constraints: BoxConstraints(maxWidth: 600), //possible change)
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/splash.png',
                                width: 200,
                                height: 130,
                                fit: BoxFit.fitHeight,
                              ),
                            ],
                          )),
                      Expanded(
                          child: Column(
                        children: [
                          Align(
                            alignment: Alignment(0, 0),
                            child: TabBar(
                              controller: _tabController,
                              tabs: [
                                Tab(text: 'Login'),
                                Tab(text: 'Register'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                LoginForm(),
                                RegisterForm(),
                              ],
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _icNumberEditingController =
      TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _icNumberEditingController,
                decoration: InputDecoration(
                  labelText: 'Ic Number',
                  // hintText: 'Enter your Ic Number...',
                  // hintStyle: TextStyle(color: Color(0xff777777)),
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.assignment_ind_rounded),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 12) {
                    return 'Please enter a valid ic number';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _passEditingController,
                obscureText: obsecurePass,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecurePass = !obsecurePass;
                        });
                      },
                      icon: obsecurePass
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black38,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                            )),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.lock),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Password must be longer than 8';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  onLogin();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => HomePage(),
                  //     ));
                }
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onLogin() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check Your Input")));
      return;
    }

    String icNumber = _icNumberEditingController.text;
    String pass = _passEditingController.text;

    try {
      // http.post(Uri.parse("${MyConfig().SERVER}/pdams/php/login.php"),
      http.post(Uri.parse("https://vppdams.000webhostapp.com/login.php"),
          body: {
            "icNumber": icNumber,
            "password": pass,
          }).then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata["status"] == 'success') {
            Doctor user;

            if (jsondata['data']['doctorID'] != null &&
                jsondata['data']['doctorID'].toLowerCase().contains('c')) {
              user = ClinicDoctor.fromJson(jsondata['data']);
            } else if (jsondata['data']['doctorID'] != null &&
                jsondata['data']['doctorID'].toLowerCase().contains('g')) {
              user = GovernmentDoctor.fromJson(jsondata['data']);
            } else {
              user = NormalUser.fromJson(jsondata['data']);
            }

            print(user.id);
            print(user.name);
            print(user.email);
            print(user.doctorID);

            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ControlScreen(user: user),
                ));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Failed")));
          }
        }
      }).timeout(const Duration(seconds: 5), onTimeout: () {});
    } on TimeoutException catch (_) {
      print("Time out");
    }
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  String selectedBloodType = bloodtype.first;

  String selectedGender = 'Male';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  final TextEditingController _passCheckEditingController =
      TextEditingController();
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _icNumberEditingController =
      TextEditingController();
  final TextEditingController _doctorIDEditingController =
      TextEditingController();
  // bool _isChecked = false;

  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _nameEditingController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.person),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _icNumberEditingController,
                decoration: InputDecoration(
                  labelText: 'Ic Number',
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.assignment_ind_rounded),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length != 12) {
                    return 'Please enter a valid ic number';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _emailEditingController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.email),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null ||
                      !value.contains("@") ||
                      !value.contains(".")) {
                    return 'Please eneter a valid email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _passEditingController,
                obscureText: obsecurePass,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecurePass = !obsecurePass;
                        });
                      },
                      icon: obsecurePass
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black38,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                            )),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.lock),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Password must be longer than 8';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: TextFormField(
                controller: _passCheckEditingController,
                obscureText: obsecurePass,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecurePass = !obsecurePass;
                        });
                      },
                      icon: obsecurePass
                          ? const Icon(
                              Icons.visibility_off_outlined,
                              color: Colors.black38,
                            )
                          : const Icon(
                              Icons.visibility_outlined,
                            )),
                  labelText: 'Confirmed Password',
                  labelStyle: TextStyle(color: Color(0xff777777)),
                  icon: Icon(Icons.lock),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff007bff), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffcccccc), width: 1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 8) {
                    return 'Password must be longer than 8';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Radio(
                    value: "Male",
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    }),
                const Text(
                  'Male',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Radio(
                    value: "Female",
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value.toString();
                      });
                    }),
                const Text(
                  'Female',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional(0.7, 0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 193, 239, 246),
                      ),
                      child: DropdownButton<String>(
                        value: selectedBloodType,
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
                            selectedBloodType = value.toString();
                          });
                        },
                        items: bloodtype
                            .map<DropdownMenuItem<String>>((String bloodtype) {
                          return DropdownMenuItem<String>(
                            value: bloodtype,
                            child: Text(bloodtype),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onRegisterNormalUserDialog,
                  child: const Text(
                    'Register Normal User',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onRegisterDoctorDialog,
                  child: Text(
                    'Register as Doctor',
                    style: TextStyle(fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }

  void onRegisterNormalUserDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check Your Form")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );

    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    String icNumber = _icNumberEditingController.text;
    String gender = selectedGender;
    String bloodtype = selectedBloodType;

    // String medicine = _icNumberEditingController.text;

    http.post(
        // Uri.parse("${MyConfig().SERVER}/pdams/php/registerNormalUser.php"),
        Uri.parse("https://vppdams.000webhostapp.com/registerNormalUser.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass,
          "icNumber": icNumber,
          "gender": gender,
          "bloodType": bloodtype,
          "medicine": "",
        }).then((response) {
      print(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }

      // if (response.statusCode == 200) {
      //   var jsondata = jsonDecode(response.body);

      //   if (jsondata['status'] == 'success') {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Registration Success")));
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Registration Failed")));
      //   }
      //   Navigator.pop(context);
      // } else {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(const SnackBar(content: Text("Registration Failed")));
      //   Navigator.pop(context);
      // }
    });
  }

  void onRegisterDoctorDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check Your Form")));
      return;
    }
    onRegisterClinicDoctorDialog();
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       shape: const RoundedRectangleBorder(
    //           borderRadius: BorderRadius.all(Radius.circular(10.0))),
    //       title: const Text(
    //         "Which doctor are you?",
    //         style: TextStyle(),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           child: const Text(
    //             "Government Doctor",
    //             style: TextStyle(),
    //           ),
    //           onPressed: () {
    //             onRegisterGovernmentDoctorDialog();
    //           },
    //         ),
    //         TextButton(
    //           child: const Text(
    //             "Clinic Doctor",
    //             style: TextStyle(),
    //           ),
    //           onPressed: () {
    //             onRegisterClinicDoctorDialog();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  void onRegisterClinicDoctorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new doctor account",
            style: TextStyle(),
          ),
          content:
              const Text("Please key in your doctor ID", style: TextStyle()),
          actions: <Widget>[
            TextFormField(
              controller: _doctorIDEditingController,
              validator: (val) => val!.isEmpty || (val.contains("C"))
                  ? "Your Doctor ID format is not correct"
                  : null,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  labelText: 'Doctor ID',
                  labelStyle: TextStyle(),
                  icon: Icon(Icons.person),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 2.0))),
            ),
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                registerClinicDoctor();
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void registerClinicDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );

    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    String icNumber = _icNumberEditingController.text;
    String gender = selectedGender;
    String bloodtype = selectedBloodType;
    String doctorID = _doctorIDEditingController.text;
    // String medicine = _icNumberEditingController.text;

    http.post(
        // Uri.parse("${MyConfig().SERVER}/pdams/php/registerClinicDoctor.php"),
        Uri.parse("https://vppdams.000webhostapp.com/registerClinicDoctor.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass,
          "icNumber": icNumber,
          "gender": gender,
          "bloodType": bloodtype,
          "doctorID": doctorID,
          "medicine": "",
        }).then((response) {
      print(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }

      // if (response.statusCode == 200) {
      //   var jsondata = jsonDecode(response.body);

      //   if (jsondata['status'] == 'success') {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Registration Success")));
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Registration Failed")));
      //   }
      //   Navigator.pop(context);
      // } else {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(const SnackBar(content: Text("Registration Failed")));
      //   Navigator.pop(context);
      // }
    });
  }

  void onRegisterGovernmentDoctorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Register new government doctor account",
            style: TextStyle(),
          ),
          content:
              const Text("Please key in your doctor ID", style: TextStyle()),
          actions: <Widget>[
            TextFormField(
              controller: _doctorIDEditingController,
              validator: (val) => val!.isEmpty || (val.contains("G"))
                  ? "Your Government Doctor ID format is not correct"
                  : null,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                  labelText: 'Government Doctor ID',
                  labelStyle: TextStyle(),
                  icon: Icon(Icons.person),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide(width: 2.0))),
            ),
            TextButton(
              child: const Text(
                "Confirm",
                style: TextStyle(),
              ),
              onPressed: () {
                registerGovernmentDoctor();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void registerGovernmentDoctor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Please Wait"),
          content: Text("Registration..."),
        );
      },
    );

    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;
    String icNumber = _icNumberEditingController.text;
    String gender = selectedGender;
    String bloodtype = selectedBloodType;
    String doctorID = _doctorIDEditingController.text;
    // String medicine = _icNumberEditingController.text;

    http.post(
        Uri.parse(
            "  https://vppdams.000webhostapp.com/registerGovernmentDoctor.php"),
        body: {
          "name": name,
          "email": email,
          "password": pass,
          "icNumber": icNumber,
          "gender": gender,
          "bloodType": bloodtype,
          "doctorID": doctorID,
        }).then((response) {
      print(response.body);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Success")));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registration Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Registration Failed")));
        Navigator.pop(context);
      }

      // if (response.statusCode == 200) {
      //   var jsondata = jsonDecode(response.body);

      //   if (jsondata['status'] == 'success') {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Registration Success")));
      //   } else {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(content: Text("Registration Failed")));
      //   }
      //   Navigator.pop(context);
      // } else {
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(const SnackBar(content: Text("Registration Failed")));
      //   Navigator.pop(context);
      // }
    });
  }
}
