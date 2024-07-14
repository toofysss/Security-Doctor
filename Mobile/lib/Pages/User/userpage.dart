import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:testing/Pages/User/home.dart';
import 'package:testing/Pages/User/report.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/services/services.dart';
import '../../constant/root.dart';
import 'package:http/http.dart' as http;

class UserPageController extends GetxController {
  PageController pageController = PageController();
  MyServices myServices = Get.put(MyServices());
  int index = 0, badge = 0;
  // Icons Of The Botoom
  List<IconData> bottomList = [
    // Icons Hmoe
    Icons.home,
    // Icons Report
    CupertinoIcons.doc_on_doc_fill
  ];
  // Pages Of The User
  List<Widget> pages = const [
    // HomePage
    UserHome(),
    // ReportPage
    ReportUser()
  ];

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
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      badge = jsonList.length;
      update();
    }
  }

  // Go To Notification Page
  notification() => Get.toNamed(AppRouting.notification);

  // Change Page
  changePage(int i) {
    index = i;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
    update();
  }

  // Go To setting Page
  setting() => Get.toNamed(AppRouting.setting);
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: UserPageController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            appBar: AppBar(
              toolbarHeight: 60,
              // Logo Of App
              title: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(logo),
                  radius: 25),
              actions: [
                // Notification Button
                Badge.count(
                  count: controller.badge,
                  child: IconButton(
                      onPressed: () => controller.notification(),
                      icon: Icon(Icons.notifications_active,
                          color: Theme.of(context).colorScheme.primary)),
                ),
                // Setting Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () => controller.setting(),
                      icon: Icon(Icons.grid_view_rounded,
                          color: Theme.of(context).colorScheme.primary)),
                )
              ],
            ),
            body: PageView.builder(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.pages.length,
                itemBuilder: (_, index) {
                  // User Pages
                  return controller.pages[index];
                }),
            //  Bottom Sheet Button
            bottomNavigationBar: CurvedNavigationBar(
                height: 60,
                index: controller.index,
                backgroundColor: Colors.transparent,
                buttonBackgroundColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).colorScheme.primary,
                items: List.generate(
                    controller.bottomList.length,
                    (index) => Icon(controller.bottomList[index],
                        size: Get.width / 14,
                        color: Theme.of(context).scaffoldBackgroundColor)),
                onTap: (index) => controller.changePage(index)),
          );
        });
  }
}
