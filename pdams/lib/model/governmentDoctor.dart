import 'package:pdams/model/doctor.dart';

class GovernmentDoctor extends Doctor {
  // String? governmentDoctorID;

  GovernmentDoctor({
    // this.governmentDoctorID,
    String? id,
    String? name,
    String? icNumber,
    String? email,
    String? gender,
    String? bloodType,
    String? doctorID,
    String? medicine,
    String? password,
  }) : super(
          id: id,
          name: name,
          icNumber: icNumber,
          email: email,
          gender: gender,
          bloodType: bloodType,
          doctorID: doctorID,
          medicine: medicine,
          password: password,
        );

  factory GovernmentDoctor.fromJson(Map<String, dynamic> json) {
    return GovernmentDoctor(
      // governmentDoctorID: json['governmentDoctorID'],
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      icNumber: json['icNumber'],
      gender: json['gender'],
      bloodType: json['bloodType'],
      doctorID: json['doctorID'],
      medicine: json['medicine'],
    );
  }
}
