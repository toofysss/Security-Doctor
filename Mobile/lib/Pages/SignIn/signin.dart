import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:testing/Modules/dropdown.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SigninController extends GetxController {
  String authpass = '';
  RxBool isloading = false.obs;
  List<DropdownItem> dropdownUserType = [];

  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController userType = TextEditingController();
  String userTypeid = "Administrator2".tr;

  @override
  void onInit() {
    getuserType();
    super.onInit();
  }

  // Code to send otp in email
  rigester() async {
    if (formKey.currentState!.validate()) {
      isloading.toggle();
      update();
      if (isloading.value) {
        var response = await http.get(
            Uri.parse("$api/Users/SendMail?Email=${email.text}"),
            headers: {"accept": "*/*"});
        if (response.statusCode == 200) {
          // Code to go to auth page with data
          var responseBody = jsonDecode(response.body);
          Get.offAllNamed(
            AppRouting.authpage,
            parameters: {
              'email': email.text,
              'password': password.text,
              "authPassword": "$responseBody",
              'name': name.text,
              'usertype': userType.text
            },
          );
        } else {
          AlertClass.snackbarwrongalert("65".tr);
          isloading.toggle();
          update();
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
      int length = jsonData.length;
      for (var i = 0; i < length - 1; i++) {
        var item = jsonData[i];
        dropdownUserType.add(DropdownItem(item['id'], item['name']));
      }
      update();
    }
  }

  // code to go to login page
  login() {
    FocusScope.of(Get.context!).unfocus();
    Get.back();
  }
}

class Signin extends StatelessWidget {
  const Signin({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SigninController(),
        builder: (controller) {
          return Scaffold(
              body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // logo of app
                    FadeInDown(
                      duration: duration,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(logo), fit: BoxFit.fill)),
                        ),
                      ),
                    ),
                    // Code To validate text field is not empty
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          // Sign in text hint
                          FadeInUp(
                            duration: duration,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Text("7".tr,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ),

                          // name text field
                          FadeInLeft(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  controller: controller.name,
                                  hints: "11".tr,
                                  iconData: Icons.person),
                            ),
                          ),

                          // email text field
                          FadeInRight(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.emailAddress,
                                  controller: controller.email,
                                  hints: "1".tr,
                                  iconData: Icons.email),
                            ),
                          ),

                          // password text field
                          FadeInLeft(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  controller: controller.password,
                                  hints: "2".tr,
                                  iconData: Icons.lock),
                            ),
                          ),

                          FadeInLeft(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
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
                                      child: Text(controller.userTypeid,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .headlineSmall),
                                    ),
                                    onChanged: (value) {
                                      controller.userTypeid = value!;
                                      controller.update();
                                    },
                                    items: controller.dropdownUserType
                                        .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  controller.userType.text =
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

                          // code to go in login if have account
                          FadeInRight(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                spacing: 15,
                                children: [
                                  Text(
                                    "8".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.login(),
                                    child: Text(
                                      "6".tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Sign in button design
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
                                  onPressed: () => controller.rigester(),
                                  child: controller.isloading.value
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
                                      : Text("4".tr,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .labelLarge)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Back Button
              Positioned(
                top: 10,
                left: lang == "en" ? 10 : null,
                right: lang == "ar" ? 10 : null,
                child: IconButton(
                  onPressed: () => controller.login(),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          ));
        });
  }
}
