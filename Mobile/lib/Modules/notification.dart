class NotificationModel {
  int? id;
  String? message;
  int? userid;
  int? status;
  int? schedule;

  NotificationModel({this.id, this.message, this.userid, this.status,this.schedule});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    userid = json['userid'];
    status = json['status'];
    schedule = json['schedule'];
  }
}
