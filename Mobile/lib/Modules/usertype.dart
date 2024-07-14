class UserTypeModel {
  int? id;
  String? name;

  UserTypeModel({this.id, this.name});

  UserTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}
