class UserInfoModel {
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

  UserInfoModel(
      {this.id,
      this.name,
      this.age,
      this.address,
      this.phone1,
      this.phone2,
      this.notes,
      this.userid,
      this.blood,
      this.gender});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    age = json['age'];
    address = json['address'];
    phone1 = json['phone1'];
    phone2 = json['phone2'];
    notes = json['notes'];
    userid = json['userid'];
    gender = json['gender'];
    blood = json['blood'];
  }
}
