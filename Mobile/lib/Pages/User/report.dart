import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testing/Modules/schedule.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/reportcard.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';

class ReportUserController extends GetxController {
  RxBool isloading = true.obs;
  RxList<ScheduleModule> reportlist = <ScheduleModule>[].obs;
  MyServices myServices = Get.put(MyServices());
  int id = 0;
  @override
  void onInit() {
    id = myServices.sharedPreferences.getInt("ID") ?? 0;
    getReport();
    super.onInit();
  }

  // To Fetch Report Data
  getReport() async {
    var response = await http.get(
        Uri.parse("$api/Operation/GetPatient?patientid=$id&usertype=1"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<ScheduleModule> report =
          jsonList.map((json) => ScheduleModule.fromJson(json)).toList();
      reportlist.assignAll(report);
      update();
    }
  }

  // To Display Report Details
  reportDetails(ScheduleModule item) {
    Get.toNamed(AppRouting.userReportDetails, arguments: item);
  }
}

class ReportUser extends StatelessWidget {
  const ReportUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder(
              init: ReportUserController(),
              builder: (controller) {
                // If No Report
                if (controller.reportlist.isEmpty &&
                    controller.isloading.value == false) {
                  return const Center(child: CustomNoData());
                }
                // If Loading Report
                if (controller.reportlist.isEmpty &&
                    controller.isloading.value == true) {
                  return const Center(child: CustomLoading());
                }
                // Display Data Like Grid 2 or >
                return GridView.builder(
                    itemCount: controller.reportlist.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 220,
                            crossAxisSpacing: 10),
                    itemBuilder: (_, index) {
                      var item = controller.reportlist[index];
                      // Report Card Design
                      return GestureDetector(
                          onTap: () => controller.reportDetails(item),
                          child: ReportCard(item: item));
                    });
              })),
    );
  }
}
