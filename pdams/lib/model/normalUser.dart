import 'package:pdams/model/doctor.dart';

class NormalUser extends Doctor {
  NormalUser({
    String? id,
    String? name,
    String? icNumber,
    String? email,
    String? gender,
    String? bloodType,
    String? medicine,
    String? password,
  }) : super(
          id: id,
          name: name,
          icNumber: icNumber,
          email: email,
          gender: gender,
          bloodType: bloodType,
          medicine: medicine,
          password: password,
        );

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    // Exclude doctor-specific properties for NormalUser
    data.remove('doctorID');
    return data;
  }

  factory NormalUser.fromJson(Map<String, dynamic> json) {
    return NormalUser(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      password: json['password'],
      icNumber: json['icNumber'],
      gender: json['gender'],
      bloodType: json['bloodType'],
      medicine: json['medicine'],
    );
  }
}
