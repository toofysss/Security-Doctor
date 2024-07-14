class UsersModel {
  int? id;
  String? email;
  String? password;
  String? name;

  UsersModel({this.id, this.email, this.password, this.name});

  UsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
  }
}
