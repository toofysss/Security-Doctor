class OperationMoudle {
  int? id;
  int? scheduleid;
  int? adminid;
  int? usertypeid;
  int? status;
  String? notes;
  String? answers;
  PatientInfo? patientInfo;

  OperationMoudle(
      {this.id,
      this.scheduleid,
      this.adminid,
      this.usertypeid,
      this.status,
      this.notes,
      this.answers,
      this.patientInfo});

  OperationMoudle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scheduleid = json['scheduleid'];
    adminid = json['adminid'];
    usertypeid = json['usertypeid'];
    status = json['status'];
    notes = json['notes'];
    answers = json['answers'];
    patientInfo = json['patientInfo'] != null
        ? PatientInfo.fromJson(json['patientInfo'])
        : null;
  }
}

class PatientInfo {
  int? id;
  String? name;
  int? age;

  PatientInfo({this.id, this.name, this.age});

  PatientInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
  }
}
