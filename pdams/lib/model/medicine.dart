class Medicine {
  String? id;
  String? icNumber;
  String? name;
  String? doctorID;
  String? patientICNumber;
  String? patientName;
  String? medicinename;
  String? timesPerDay;
  String? date;
  String? time;
  String? type;
  String? tabletsCapsules;
  String? timing;
  String? food;

  Medicine({
    required this.id,
    required this.icNumber,
    required this.doctorID,
    required this.name,
    required this.patientICNumber,
    required this.patientName,
    required this.medicinename,
    required this.date,
    required this.time,
    required this.type,
    required this.timesPerDay,
    required this.tabletsCapsules,
    required this.timing,
    required this.food,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['ID'],
      icNumber: json['ICNumber'],
      name: json['name'],
      doctorID: json['doctorID'],
      patientICNumber: json['patientICNumber'],
      patientName: json['patientName'],
      medicinename: json['medicineName'],
      date: json['date'],
      time: json['time'],
      type: json['type'],
      timesPerDay: json['timesPerDay'],
      tabletsCapsules: json['tabletsCapsules'],
      timing: json['timing'],
      food: json['food'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['icNumber'] = icNumber;
    data['doctorID'] = doctorID;
    data['name'] = name;
    data['patientICNumber'] = patientICNumber;
    data['patientName'] = patientName;
    data['medicinename'] = medicinename;
    data['date'] = date;
    data['time'] = time;
    data['timesPerDay'] = timesPerDay;
    data['type'] = type;
    data['tabletsCapsules'] = tabletsCapsules;
    data['timing'] = timing;
    data['food'] = food;
    return data;
  }
}
