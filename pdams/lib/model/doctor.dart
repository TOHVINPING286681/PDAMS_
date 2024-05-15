class Doctor {
  String? id;
  String? name;
  String? icNumber;
  String? email;
  String? gender;
  String? bloodType;
  String? doctorID;
  String? medicine;
  String? password;

  Doctor({
    this.id,
    this.name,
    this.icNumber,
    this.email,
    this.gender,
    this.bloodType,
    this.doctorID,
    this.medicine,
    this.password,
  });

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    icNumber = json['icNumber'];
    gender = json['gender'];
    bloodType = json['bloodType'];
    doctorID = json['doctorID'];
    medicine = json['medicine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['icNumber'] = icNumber;
    data['gender'] = gender;
    data['bloodType'] = bloodType;
    data['doctorID'] = doctorID;
    data['medicine'] = medicine;
    return data;
  }
}
