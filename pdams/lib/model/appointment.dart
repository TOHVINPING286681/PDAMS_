class Appointment {
  String? id;
  String? icNumber;
  String? name;
  String? patientICNumber;
  String? patientName;
  String? appointmentName;
  String? date;
  String? time;
  String? type;
  String? status;
  String? state;

  Appointment({
    required this.id,
    required this.icNumber,
    required this.name,
    required this.patientICNumber,
    required this.patientName,
    required this.appointmentName,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.state,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['ID'],
      icNumber: json['ICNumber'],
      name: json['name'],
      patientICNumber: json['patientICNumber'],
      patientName: json['patientName'],
      appointmentName: json['appointmentName'],
      date: json['date'],
      time: json['time'],
      type: json['type'],
      status: json['status'],
      state: json['state'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icNumber'] = icNumber;
    data['name'] = name;
    data['patientICNumber'] = patientICNumber;
    data['patientName'] = patientName;
    data['appointmentName'] = appointmentName;
    data['date'] = date;
    data['time'] = time;
    data['status'] = status;
    data['state'] = state;
    return data;
  }
}
