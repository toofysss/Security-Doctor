class UserHomeModule {
  int? id;
  String? dscrp;
  List<Admininfo>? admininfo;

  UserHomeModule({this.id, this.dscrp, this.admininfo});

  UserHomeModule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dscrp = json['dscrp'];
    if (json['admininfo'] != null) {
      admininfo = <Admininfo>[];
      json['admininfo'].forEach((v) {
        admininfo!.add(Admininfo.fromJson(v));
      });
    }
  }
}

class Admininfo {
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

  Admininfo(
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

  Admininfo.fromJson(Map<String, dynamic> json) {
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
