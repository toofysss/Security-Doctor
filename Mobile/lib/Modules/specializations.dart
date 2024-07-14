class SpecializationsModel {
  int? id;
  String? dscrp;

  SpecializationsModel({this.id, this.dscrp});

  SpecializationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dscrp = json['dscrp'];
  }
}
