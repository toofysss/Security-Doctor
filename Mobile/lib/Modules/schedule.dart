class ScheduleModule {
  int? id;
  PatientInfo? patientInfo;
  AdminInfo? adminInfo;
  int? status;
  String? opendate;
  String? closedate;
  List<Operation>? operation;

  ScheduleModule(
      {this.id,
      this.patientInfo,
      this.adminInfo,
      this.status,
      this.opendate,
      this.closedate,
      this.operation});

  ScheduleModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientInfo = json['patientInfo'] != null
        ? PatientInfo.fromJson(json['patientInfo'])
        : null;
    adminInfo = json['adminInfo'] != null
        ? AdminInfo.fromJson(json['adminInfo'])
        : null;
    status = json['status'];
    opendate = json['opendate'];
    closedate = json['closedate'];
    if (json['operation'] != null) {
      operation = <Operation>[];
      json['operation'].forEach((v) {
        operation!.add(Operation.fromJson(v));
      });
    }
  }
}

class PatientInfo {
  int? id;
  String? name;
  int? age;
  String? address;
  String? phone1;
  String? phone2;
  String? notes;
  String? blood;
  int? userid;
  int? gender;

  PatientInfo(
      {this.id,
      this.name,
      this.age,
      this.address,
      this.phone1,
      this.phone2,
      this.notes,
      this.blood,
      this.userid,
      this.gender});

  PatientInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    address = json['address'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    notes = json['notes'];
    blood = json['blood'];
    userid = json['userid'];
    gender = json['gender'];
  }
}

class AdminInfo {
  int? id;
  String? name;
  String? address;
  String? worklocation;
  String? workopen;
  String? workclose;
  String? phone;
  String? workdays;
  String? dscrp;
  String? depart;
  String? image;
  int? userid;

  AdminInfo(
      {this.id,
      this.name,
      this.address,
      this.worklocation,
      this.workopen,
      this.workclose,
      this.phone,
      this.workdays,
      this.dscrp,
      this.depart,
      this.image,
      this.userid});

  AdminInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    worklocation = json['worklocation'];
    workopen = json['workopen'];
    workclose = json['workclose'];
    phone = json['phone'];
    workdays = json['workdays'];
    dscrp = json['dscrp'];
    depart = json['depart'];
    image = json['image'];
    userid = json['userid'];
  }
}

class Operation {
  int? id;
  int? status;
  String? notes;
  String? answers;
  int? usertypeid;
  OperationAdminInfo? operationAdminInfo;
  List<OperationImage>? operationImage;

  Operation(
      {this.id,
      this.status,
      this.usertypeid,
      this.notes,
      this.answers,
      this.operationAdminInfo,
      this.operationImage});

  Operation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    usertypeid = json['usertypeid'];
    notes = json['notes'];
    answers = json['answers'];
    operationAdminInfo = json['operationAdminInfo'] != null
        ? OperationAdminInfo.fromJson(json['operationAdminInfo'])
        : null;
    if (json['operationImage'] != null) {
      operationImage = <OperationImage>[];
      json['operationImage'].forEach((v) {
        operationImage!.add(OperationImage.fromJson(v));
      });
    }
  }
}

class OperationAdminInfo {
  int? id;
  String? name;
  String? image;
  String? depart;

  OperationAdminInfo({this.id, this.name, this.image, this.depart});

  OperationAdminInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    depart = json['depart'];
  }
}

class OperationImage {
  String? image;

  OperationImage({this.image});

  OperationImage.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }
}
