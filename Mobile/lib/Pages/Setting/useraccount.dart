import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testing/Modules/dropdown.dart';
import 'package:testing/Modules/userinfo.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';

class UserAccountController extends GetxController {
  MyServices myServices = Get.put(MyServices());

  RxList<UserInfoModel> usersList = <UserInfoModel>[].obs;
  int id = 0;
  final formKey = GlobalKey<FormState>();

  RxBool isloading = true.obs, loadingsave = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone1 = TextEditingController();
  TextEditingController phone2 = TextEditingController();
  TextEditingController gendertype = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController blood = TextEditingController();
  String genderid = "39".tr;
  // dropdown for gender
  List<DropdownItem> dropdownUserType = [
    // Male
    DropdownItem(0, "40".tr),
    // FeMale
    DropdownItem(1, "41".tr)
  ];
  @override
  void onInit() {
    id = myServices.sharedPreferences.getInt("ID") ?? 0;
    getUsersInfo();
    super.onInit();
  }

  // code to display userinfo from database
  getUsersInfo() async {
    isloading.toggle();
    var response = await http.get(
        Uri.parse("$api/PaitentIfno/PaitentInfo?userid=$id"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<UserInfoModel> userList =
          jsonList.map((json) => UserInfoModel.fromJson(json)).toList();
      usersList.assignAll(userList);
      age.text = "${userList[0].age}";
      name.text = "${userList[0].name}";
      address.text = "${userList[0].address}";
      phone1.text = "${userList[0].phone1}";
      phone2.text = "${userList[0].phone2}";
      gendertype.text = "${userList[0].gender}";
      genderid = gendertype.text == "0" ? "40".tr : "41".tr;
      notes.text = "${userList[0].notes}";
      blood.text = "${userList[0].blood}";
      update();
    }
  }

  // save/update user info in database
  save() async {
    if (formKey.currentState!.validate()) {
      loadingsave.toggle();
      update();
      if (loadingsave.value == true) {
        Map<String, dynamic> data = {
          "id": 0,
          "name": name.text,
          "age": age.text,
          "address": address.text,
          "phone1": phone1.text,
          "phone2": phone2.text,
          "userid": id,
          "gender": gendertype.text,
          "notes": notes.text,
          "blood": blood.text,
        };
        var response = await http.put(
          Uri.parse("$api/PaitentIfno/Update"),
          body: jsonEncode(data),
          headers: {"accept": "*/*", "Content-Type": "application/json"},
        );
        if (response.statusCode == 200) {
          loadingsave.toggle();
          update();
          AlertClass.snackbarsuccessalert("29".tr);
        }
      }
    }
  }
}

class UserAccount extends StatelessWidget {
  const UserAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: UserAccountController(),
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
                // setting title
                title: Text("Settting0".tr,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              body: Obx(() {
                // if data is loading
                if (controller.isloading.value == true &&
                    controller.usersList.isEmpty) {
                  return const Center(child: CustomLoading());
                }
                // if data is empty
                else if (controller.isloading.value == false &&
                    controller.usersList.isEmpty) {
                  return const Center(child: CustomNoData());
                } else {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      // validate text field to not empty
                      key: controller.formKey,
                      child: Column(
                        children: [
                          // name text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.text,
                                  controller: controller.name,
                                  hints: "11".tr),
                            ),
                          ),

                          // age text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.number,
                                  controller: controller.age,
                                  hints: "21".tr),
                            ),
                          ),

                          // address text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: false,
                                  textInputType: TextInputType.streetAddress,
                                  controller: controller.address,
                                  hints: "15".tr),
                            ),
                          ),

                          // notes text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: false,
                                  textInputType: TextInputType.text,
                                  controller: controller.notes,
                                  hints: "42".tr),
                            ),
                          ),

                          // blood text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: false,
                                  textInputType: TextInputType.text,
                                  controller: controller.blood,
                                  hints: "66".tr),
                            ),
                          ),

                          // Gender dropdown
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Material(
                                elevation: 6,
                                shadowColor:
                                    Theme.of(Get.context!).colorScheme.primary,
                                borderRadius: BorderRadius.circular(30),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    isExpanded: true,
                                    iconEnabledColor: Theme.of(Get.context!)
                                        .colorScheme
                                        .primary,
                                    iconDisabledColor: Theme.of(Get.context!)
                                        .colorScheme
                                        .primary,
                                    hint: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(controller.genderid,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .headlineSmall),
                                    ),
                                    onChanged: (value) {
                                      controller.genderid = value!;
                                      controller.update();
                                    },
                                    items: controller.dropdownUserType
                                        .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  controller.gendertype.text =
                                                      "${value.value}";
                                                  controller.update();
                                                },
                                                value: value.label,
                                                alignment: Alignment.center,
                                                child: Center(
                                                  child: Text(value.label,
                                                      style:
                                                          Theme.of(Get.context!)
                                                              .textTheme
                                                              .headlineSmall),
                                                )))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // phone text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.number,
                                  controller: controller.phone1,
                                  hints: "16".tr),
                            ),
                          ),
                          // phone2 text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  textInputType: TextInputType.number,
                                  controller: controller.phone2,
                                  hints: "17".tr),
                            ),
                          ),
                          // save button
                          FadeInUp(
                            duration: duration,
                            child: Container(
                              width: Get.width,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(55),
                                      animationDuration:
                                          const Duration(seconds: 3),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      shape: const StadiumBorder()),
                                  onPressed: () => controller.save(),
                                  child: controller.loadingsave.value
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Text("5".tr,
                                                  style: Theme.of(Get.context!)
                                                      .textTheme
                                                      .labelLarge),
                                            )
                                          ],
                                        )
                                      : Text("33".tr,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .labelLarge)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }));
        });
  }
}
