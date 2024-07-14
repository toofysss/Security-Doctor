import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/specializations.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:http/http.dart' as http;
import 'package:testing/constant/root.dart';

class SpecializationsController extends GetxController {
  RxList<SpecializationsModel> specializationslist =
      <SpecializationsModel>[].obs;
  RxBool isloading = true.obs, loadingsave = false.obs;
  TextEditingController dscrp = TextEditingController();

  @override
  void onInit() {
    getspecializations();
    super.onInit();
  }

  // Code to operation (insert,update,delete)
  dataoperation(int id, operation) async {
    loadingsave.toggle();
    update();
    Get.forceAppUpdate();
    if (loadingsave.value) {
      FocusScope.of(Get.context!).unfocus();
      Map<String, dynamic> data = {
        "id": id,
        "dscrp": dscrp.text,
      };
      if (operation == 0) {
        var response = await http.post(
            Uri.parse("$api/Department/InsertDepart"),
            headers: {"accept": "*/*", "Content-Type": "application/json"},
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          loadingsave.toggle();
          update();
          dscrp.clear();
          getspecializations();
          Get.back();
        }
      } else if (operation == 1) {
        var response = await http.put(Uri.parse("$api/Department/UpdateDepart"),
            headers: {"accept": "*/*", "Content-Type": "application/json"},
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          loadingsave.toggle();
          update();
          dscrp.clear();
          getspecializations();
          Get.back();
        }
      } else {
        var response = await http.delete(
            Uri.parse("$api/Department/DeleteDepart?id=$id"),
            headers: {"accept": "*/*"});
        if (response.statusCode == 200) {
          loadingsave.toggle();
          update();
          dscrp.clear();
          getspecializations();
          Get.back();
        }
      }
    }
  }

  // Get data of specializations
  getspecializations() async {
    var response = await http.get(Uri.parse("$api/Department/AllDepart"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();

      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<SpecializationsModel> specializations =
          jsonList.map((json) => SpecializationsModel.fromJson(json)).toList();
      specializationslist.assignAll(specializations);
      update();
    }
  }

  // Alert To Confirm Delete data
  deletealert(int id, operation) {
    return AlertClass.deletealert(
        loadingsave, () => dataoperation(id, operation));
  }

  // alert to set operation (insert,update)
  alert(int id, operation) {
    return AlertClass.opertationalert(loadingsave,
        () => dataoperation(id, operation), dscrp, "Administrator0".tr);
  }
}

class Specializations extends StatelessWidget {
  const Specializations({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SpecializationsController(),
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
                    )),
                centerTitle: true,

                // Specializations title
                title: Text("Administrator0".tr,
                    style: Theme.of(context).textTheme.titleSmall),
                actions: [
                  // add button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: IconButton(
                        highlightColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.1),
                        onPressed: () => controller.alert(0, 0),
                        icon: Icon(
                          Icons.add,
                          size: Get.width / 14,
                        )),
                  )
                ],
              ),
              body: Obx(() {
                // if data is loading
                if (controller.isloading.value == true &&
                    controller.specializationslist.isEmpty) {
                  return const Center(child: CustomLoading());
                }
                // if data is empty
                else if (controller.isloading.value == false &&
                    controller.specializationslist.isEmpty) {
                  return const Center(child: CustomNoData());
                } else {
                  // display data like list

                  return ListView.builder(
                      itemCount: controller.specializationslist.length,
                      itemBuilder: (_, index) {
                        var item = controller.specializationslist[index];
                        return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    item.dscrp!,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  )),
                                  PopupMenuButton(
                                      constraints:
                                          const BoxConstraints(maxWidth: 70),
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      shadowColor:
                                          Theme.of(context).shadowColor,
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () {
                                                controller.dscrp.text =
                                                    item.dscrp!;
                                                controller.alert(item.id!, 1);
                                              },
                                              child: Center(
                                                  child: Text("35".tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall)),
                                            ),
                                            PopupMenuItem(
                                              onTap: () {
                                                controller.deletealert(
                                                    item.id!, 2);
                                              },
                                              child: Center(
                                                  child: Text("36".tr,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall)),
                                            )
                                          ]),
                                ]));
                      });
                }
              }));
        });
  }
}
