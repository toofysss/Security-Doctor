import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/usertype.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/constant/root.dart';
import 'package:http/http.dart' as http;

class UsersTypeController extends GetxController {
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;
  RxBool isloading = true.obs, loadingsave = false.obs;
  TextEditingController dscrp = TextEditingController();

  @override
  void onInit() {
    getUserType();
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
        "name": dscrp.text,
      };
      if (operation == 0) {
        var response = await http.post(Uri.parse("$api/UserTypes/Insert"),
            headers: {"accept": "*/*", "Content-Type": "application/json"},
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          getUserType();
          dscrp.clear();
          loadingsave.toggle();
          update();
          Get.back();
        }
      } else if (operation == 1) {
        var response = await http.put(Uri.parse("$api/UserTypes/Update"),
            headers: {"accept": "*/*", "Content-Type": "application/json"},
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          getUserType();
          dscrp.clear();
          loadingsave.toggle();
          update();
          Get.back();
        }
      } else {
        var response = await http.delete(
            Uri.parse("$api/UserTypes/Delete?id=$id"),
            headers: {"accept": "*/*"});
        if (response.statusCode == 200) {
          dscrp.clear();
          getUserType();
          loadingsave.toggle();
          update();
          Get.back();
        }
      }
    }
  }

// Get data of usertypes
  getUserType() async {
    var response = await http.get(Uri.parse("$api/UserTypes/AllUserType"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<UserTypeModel> usertypeList =
          jsonList.map((json) => UserTypeModel.fromJson(json)).toList();
      userTypeList.assignAll(usertypeList);
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
    return AlertClass.opertationalert(isloading,
        () => dataoperation(id, operation), dscrp, "Administrator2".tr);
  }
}

class UsersType extends StatelessWidget {
  const UsersType({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: UsersTypeController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                // Back button
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
                // usertype title
                title: Text("Administrator2".tr,
                    style: Theme.of(context).textTheme.titleSmall),
                actions: [
                  // add usertype button
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
                    controller.userTypeList.isEmpty) {
                  return const Center(child: CustomLoading());
                }
                // if data is empty
                else if (controller.isloading.value == false &&
                    controller.userTypeList.isEmpty) {
                  return const Center(child: CustomNoData());
                } else {
                  // display data like list
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.userTypeList.length,
                      itemBuilder: (_, index) => Container(
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
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Text(
                                  controller.userTypeList[index].name!,
                                  style: Theme.of(context).textTheme.titleSmall,
                                )),
                                PopupMenuButton(
                                    constraints:
                                        const BoxConstraints(maxWidth: 70),
                                    iconColor:
                                        Theme.of(context).colorScheme.secondary,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    shadowColor: Theme.of(context).shadowColor,
                                    itemBuilder: (context) => [
                                          PopupMenuItem(
                                            onTap: () {
                                              controller.dscrp.text = controller
                                                  .userTypeList[index].name!;
                                              controller.alert(
                                                  controller
                                                      .userTypeList[index].id!,
                                                  1);
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
                                                  controller
                                                      .userTypeList[index].id!,
                                                  2);
                                            },
                                            child: Center(
                                                child: Text("36".tr,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall)),
                                          )
                                        ]),
                              ])));
                }
              }));
        });
  }
}
