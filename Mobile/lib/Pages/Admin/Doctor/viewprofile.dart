import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/schedule.dart';
import 'package:http/http.dart' as http;
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/reportcard.dart';
import 'package:testing/constant/root.dart';

class ViewProfileController extends GetxController {
  String? id;
  RxBool isloading = true.obs;
  RxList<ScheduleModule> reportlist = <ScheduleModule>[].obs;
  ViewProfileController(this.id);

  @override
  void onInit() {
    getReport();
    super.onInit();
  }

  // To Fetch Report Data
  getReport() async {
    var response = await http.get(
        Uri.parse("$api/Operation/GetProfile?patientid=$id&usertype=1"),
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

class ViewProfile extends StatelessWidget {
  final String id;
  final String title;
  const ViewProfile({required this.id, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ViewProfileController(id),
        builder: (controller) {
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
                  )),
              // Name Of Doctor
              title: Text(title, style: Theme.of(context).textTheme.titleSmall),
            ),
            body: Obx(() {
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            }),
          );
        });
  }
}
