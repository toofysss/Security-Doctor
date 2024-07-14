class AdminInfoModel {
  int? id;
  String? name;
  String? address;
  int? userid;
  int? departid;
  String? worklocation;
  String? workopen;
  String? workclose;
  String? workdays;
  String? phone;
  String? dscrp;
  String? image;

  AdminInfoModel(
      {this.id,
      this.name,
      this.address,
      this.userid,
      this.departid,
      this.worklocation,
      this.workopen,
      this.workclose,
      this.workdays,
      this.phone,
      this.dscrp,
      this.image});

  AdminInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    userid = json['userid'];
    departid = json['departid'];
    worklocation = json['worklocation'];
    workopen = json['workopen'];
    workclose = json['workclose'];
    workdays = json['workdays'];
    phone = json['phone'];
    dscrp = json['dscrp'];
    image = json['image'];
  }
}
