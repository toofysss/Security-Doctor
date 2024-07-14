import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/schedule.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/doctorcard.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';
import 'package:http/http.dart' as http;

class DoctorController extends GetxController {
  RxBool isloading = true.obs;

  RxList<ScheduleModule> reservationslist = <ScheduleModule>[].obs;
  RxList<ScheduleModule> filteredreservationslist = <ScheduleModule>[].obs;
  TextEditingController search = TextEditingController();
  MyServices myServices = Get.put(MyServices());
  int id = 0;

  @override
  void onInit() {
    id = myServices.sharedPreferences.getInt("ID") ?? 0;
    getdoctor();
    super.onInit();
  }

  // code to get data of doctor
  getdoctor() async {
    var response = await http.get(
        Uri.parse("$api/Schedule/GetAll?adminid=$id&status=0"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<ScheduleModule> report =
          jsonList.map((json) => ScheduleModule.fromJson(json)).toList();
      reservationslist.assignAll(report);
      filteredreservationslist.assignAll(report);
      update();
    }
  }

  // code to filter data by paitent name
  filterAdminInfo(String query) {
    filteredreservationslist.assignAll(reservationslist
        .where((schedule) =>
            schedule.patientInfo != null &&
            schedule.patientInfo!.name!
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList());
  }

  // View Paitient Info
  viewProfile(ScheduleModule? patientInfo) =>
      Get.toNamed(AppRouting.viewprofile, parameters: {
        "id": "${patientInfo!.patientInfo!.id}",
        "title": "${patientInfo.patientInfo!.name}"
      });
  // Share Paitient Info
  shareProfile(ScheduleModule? scheduleModule) =>
      Get.toNamed(AppRouting.shareprofile,
          parameters: {
            "title": "56".tr,
          },
          arguments: scheduleModule);
  // Request Laboratories
  requestAnalytics(ScheduleModule? scheduleModule) =>
      Get.toNamed(AppRouting.operationRequest,
          parameters: {
            "usertype": "2",
            "title": "57".tr,
          },
          arguments: scheduleModule);
  // Request Pharmacies
  requestTreatment(ScheduleModule? scheduleModule) =>
      Get.toNamed(AppRouting.operationRequest,
          parameters: {
            "usertype": "3",
            "title": "58".tr,
          },
          arguments: scheduleModule);
}

class Doctors extends StatelessWidget {
  const Doctors({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DoctorController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                // back button
                leading: IconButton(
                  highlightColor:
                      Theme.of(context).colorScheme.primary.withOpacity(.1),
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: Get.width / 18,
                  ),
                ),
                centerTitle: true,
                // doctor title
                title: Text("Admin0".tr,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Text Field To Filter Data
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: CustomTextField(
                        onChange: (value) => controller.filterAdminInfo(value),
                        controller: controller.search,
                        hints: "26".tr,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    Obx(() {
                      // If Data Is loading

                      if (controller.isloading.value &&
                          controller.filteredreservationslist.isEmpty) {
                        return const Center(child: CustomLoading());
                      }
                      // If Data Is empty

                      else if (controller.isloading.value == false &&
                          controller.filteredreservationslist.isEmpty) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: CustomNoData(),
                        ));
                      } else {
                        // Display Data Like list
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                controller.filteredreservationslist.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              var item =
                                  controller.filteredreservationslist[index];
                              // Docotr Card Design
                              return DoctorCard(
                                  controller: controller, item: item);
                            });
                      }
                    })
                  ],
                ),
              ));
        });
  }
}
