import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:testing/Modules/dropdown.dart';
import 'package:testing/Modules/users.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/constant/root.dart';
import '../../UI/textfield.dart';

class UsersController extends GetxController {
  RxList<UsersModel> usersList = <UsersModel>[].obs;
  RxBool isloading = true.obs, loadingsave = false.obs;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userType = TextEditingController();
  String userTypeid = "Administrator2".tr;
  List<DropdownItem> dropdownUserType = [];

  @override
  void onInit() {
    getuserType();
    getUsers();
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
        "email": email.text,
        "password": password.text,
        "usertype": userType.text
      };

      if (operation == 0) {
        var response = await http.post(Uri.parse("$api/Users/Insert"),
            headers: {"accept": "*/*", "Content-Type": "application/json"},
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          getUsers();
          loadingsave.toggle();
          update();
          Get.back();
        }
      } else {
        var response = await http.delete(Uri.parse("$api/Users/Delete?id=$id"),
            headers: {"accept": "*/*"});
        if (response.statusCode == 200) {
          getUsers();
          loadingsave.toggle();
          update();
          Get.back();
        }
      }
    }
  }

  // Get data of usertypes
  getuserType() async {
    dropdownUserType.clear();
    final response = await http.get(Uri.parse('$api/UserTypes/AllUserType'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        dropdownUserType.add(DropdownItem(item['id'], item['name']));
      }
      update();
    }
  }

  // Get data of Users
  getUsers() async {
    var response = await http.get(Uri.parse("$api/Users/AllUsers"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<UsersModel> userList =
          jsonList.map((json) => UsersModel.fromJson(json)).toList();
      usersList.assignAll(userList);
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
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: CustomTextField(hints: "1".tr, controller: email),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: CustomTextField(hints: "2".tr, controller: password),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Material(
              elevation: 6,
              shadowColor: Theme.of(Get.context!).colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  isExpanded: true,
                  iconEnabledColor: Theme.of(Get.context!).colorScheme.primary,
                  iconDisabledColor: Theme.of(Get.context!).colorScheme.primary,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(userTypeid,
                        style: Theme.of(Get.context!).textTheme.headlineSmall),
                  ),
                  onChanged: (value) {
                    userTypeid = value!;
                    update();
                    Get.forceAppUpdate();
                  },
                  items: dropdownUserType
                      .map<DropdownMenuItem<String>>(
                          (value) => DropdownMenuItem<String>(
                              onTap: () {
                                userType.text = "${value.value}";
                                update();
                              },
                              value: value.label,
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(value.label,
                                    style: Theme.of(Get.context!)
                                        .textTheme
                                        .headlineSmall),
                              )))
                      .toList(),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: Get.width / 3.5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: () => dataoperation(id, operation),
                        child: loadingsave.value
                            ? CircularProgressIndicator(
                                color: Theme.of(Get.context!)
                                    .scaffoldBackgroundColor)
                            : Text("33".tr,
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .labelLarge)),
                  )),
              GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: Get.width / 3.5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: () => Get.back(),
                        child: Text("34".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: UsersController(),
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
                // users title
                title: Text("Administrator1".tr,
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
                if (controller.isloading.value &&
                    controller.usersList.isEmpty) {
                  return const Center(child: CustomLoading());
                }

                // if data is empty
                else if (controller.isloading.value == false &&
                    controller.usersList.isEmpty) {
                  return const Center(child: CustomNoData());
                } else {
                  // display data like list

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.usersList.length,
                      itemBuilder: (_, index) {
                        var item = controller.usersList[index];
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
                                    item.email!,
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
                                                controller.deletealert(
                                                    controller
                                                        .usersList[index].id!,
                                                    2);
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
