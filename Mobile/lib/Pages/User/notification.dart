import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/notification.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/notificationcard.dart';
import 'package:testing/constant/root.dart';
import 'package:http/http.dart' as http;
import 'package:testing/services/services.dart';

class NotificationPageController extends GetxController {
  RxList<NotificationModel> notificationlist = <NotificationModel>[].obs;

  RxBool isloading = true.obs,
      loadingsave = false.obs,
      loadingreject = false.obs;

  MyServices myServices = Get.put(MyServices());
  @override
  void onInit() {
    getnotification();
    super.onInit();
  }

  // Code To Fetch All Notification Where Not Read It
  getnotification() async {
    int i = myServices.sharedPreferences.getInt("ID") ?? 0;
    var response = await http.get(
        Uri.parse("$api/Notification/AllNotification?id=$i&status=0"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();

      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<NotificationModel> notifications =
          jsonList.map((json) => NotificationModel.fromJson(json)).toList();
      notificationlist.assignAll(notifications);
      update();
    }
  }

  // Code To Update Notification if Accepted or Rejected
  updateNotification(int status, int id, int schedule) async {
    if (status == 0) {
      loadingreject.toggle();
    } else {
      loadingsave.toggle();
    }
    update();
    if (loadingsave.value || loadingreject.value) {
      Map<String, dynamic> data = {
        "id": id,
        "status": status,
        "schedule": schedule
      };
      var response = await http.put(
          Uri.parse("$api/Notification/UpdateMessage"),
          headers: {"accept": "text/plain", "Content-Type": "application/json"},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        if (status == 0) {
          loadingreject.toggle();
        } else {
          loadingsave.toggle();
        }
        notificationlist.removeWhere((notification) => notification.id == id);
        update();
        AlertClass.snackbarsuccessalert("29".tr);
      }
    }
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        // Back Button
        leading: IconButton(
            highlightColor:
                Theme.of(context).colorScheme.primary.withOpacity(.1),
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: Get.width / 18,
              color: Theme.of(context).colorScheme.primary,
            )),
        // Title Notification
        title: Text(
          "27".tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: GetBuilder<NotificationPageController>(
        init: NotificationPageController(),
        builder: (controller) {
          // If Notificaition loading
          if (controller.notificationlist.isEmpty &&
              controller.isloading.value) {
            return const Center(child: CustomLoading());
          }
          // if notification empty
          else if (controller.notificationlist.isEmpty &&
              controller.isloading.value == false) {
            return const Center(child: CustomNoData());
          } else {
            // Display Data Like list
            return ListView.builder(
                itemCount: controller.notificationlist.length,
                itemBuilder: (_, index) {
                  var item = controller.notificationlist[index];
                  //  notification design
                  return CustomNotificationCard(
                      item: item, controller: controller);
                });
          }
        },
      ),
    );
  }
}
