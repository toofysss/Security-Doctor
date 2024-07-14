import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/operation.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/laboratoriescard.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';
import 'package:http/http.dart' as http;

class LaboratoriesController extends GetxController {
  RxBool isloading = true.obs;
  RxList<OperationMoudle> datalist = <OperationMoudle>[].obs;
  RxList<OperationMoudle> filtereddatalist = <OperationMoudle>[].obs;
  MyServices myServices = Get.put(MyServices());
  int id = 0;
  TextEditingController search = TextEditingController();
  @override
  void onInit() {
    id = myServices.sharedPreferences.getInt("ID") ?? 0;
    getdata();
    super.onInit();
  }

  // Get Data for Laboratories
  getdata() async {
    var response = await http.get(
        Uri.parse("$api/Operation/GetAll?adminid=$id&status=0&usertype=2"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<OperationMoudle> report =
          jsonList.map((json) => OperationMoudle.fromJson(json)).toList();
      datalist.assignAll(report);
      filtereddatalist.assignAll(report);
      update();
    }
  }

  viewTreminate(OperationMoudle item) {
    Get.toNamed(AppRouting.viewlaboratories, arguments: item);
  }

  // Code to filter data by paitent name
  filterData(String query) {
    filtereddatalist.assignAll(datalist
        .where((schedule) =>
            schedule.patientInfo != null &&
            schedule.patientInfo!.name!
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList());
  }
}

class Laboratories extends StatelessWidget {
  const Laboratories({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LaboratoriesController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
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
                // Laboratories title
                title: Text("Admin1".tr,
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
                        onChange: (value) => controller.filterData(value),
                        controller: controller.search,
                        hints: "26".tr,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    Obx(() {
                      // If Data Is loading

                      if (controller.isloading.value &&
                          controller.filtereddatalist.isEmpty) {
                        return const Center(child: CustomLoading());
                      }
                      // If Data Is Empty

                      else if (controller.isloading.value == false &&
                          controller.filtereddatalist.isEmpty) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: CustomNoData(),
                        ));
                      } else {
                        // Display Data Like list

                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.filtereddatalist.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              var item = controller.filtereddatalist[index];
                              return CustomLaboratoriesCard(
                                  item: item, controller: controller);
                            });
                      }
                    })
                  ],
                ),
              ));
        });
  }
}
