import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/notification.dart';
import 'package:testing/Pages/User/notification.dart';

class CustomNotificationCard extends StatelessWidget {
  final NotificationModel item;
  final NotificationPageController controller;
  const CustomNotificationCard(
      {required this.item, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              blurRadius: 28,
              offset: Offset(0, 14),
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.22),
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message of notification
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(item.message!,
                  style: Theme.of(context).textTheme.titleSmall)),

          // Button Design
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //  Accept Button
              SizedBox(
                width: Get.width / 2.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        animationDuration: const Duration(seconds: 3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: const StadiumBorder()),
                    onPressed: () => controller.updateNotification(
                        1, item.id!, item.schedule!),
                    child: controller.loadingsave.value
                        ? CircularProgressIndicator(
                            color: Theme.of(context).scaffoldBackgroundColor)
                        : Text("59".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
              ),
              // Reject Button
              SizedBox(
                width: Get.width / 2.5,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(55),
                        animationDuration: const Duration(seconds: 3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: const StadiumBorder()),
                    onPressed: () => controller.updateNotification(
                        0, item.id!, item.schedule!),
                    child: controller.loadingreject.value
                        ? CircularProgressIndicator(
                            color: Theme.of(context).scaffoldBackgroundColor)
                        : Text("60".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
