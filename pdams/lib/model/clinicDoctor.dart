import 'package:pdams/model/doctor.dart';

class ClinicDoctor extends Doctor {
  // String? clinicDoctorID;

  ClinicDoctor({
    // this.clinicDoctorID,
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

  // @override
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = super.toJson();
  //   data['clinicDoctorID'] = clinicDoctorID;
  //   return data;
  // }

  factory ClinicDoctor.fromJson(Map<String, dynamic> json) {
    return ClinicDoctor(
      // clinicDoctorID: json['clinicDoctorID'],
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
