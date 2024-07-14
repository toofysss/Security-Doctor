import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testing/services/services.dart';

class LoginController extends GetxController {
  MyServices myServices = Get.put(MyServices());
  RxBool showpass = true.obs, isloading = false.obs;
  final formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  // Code to view and hide password
  viewpass() {
    showpass.toggle();
    update();
  }

  // Go to rigester page
  rigester() {
    FocusScope.of(Get.context!).unfocus();
    Get.toNamed(AppRouting.signin);
  }

  // Save Data In Device
  savingData(responseBody) async {
    myServices.sharedPreferences.setString("login", responseBody['name']);
    myServices.sharedPreferences.setInt("usertype", responseBody['usertype']);

    myServices.sharedPreferences.setInt("ID", responseBody['id']);
    // check if user  is user
    if (responseBody['name'] == "User") {
      await FirebaseMessaging.instance
          .subscribeToTopic("${responseBody['id']}");

      Get.offAllNamed(AppRouting.home);
    }
    // check if user  is administrator
    else if (responseBody['name'] == "admin") {
      Get.offAllNamed(AppRouting.administrator);
    }
    // check if user  is admin
    else {
      Get.offAllNamed(AppRouting.admin);
    }
  }

  // Go to login to app
  login() async {
    if (formKey.currentState!.validate()) {
      isloading.toggle();
      update();
      if (isloading.value == true) {
        FocusScope.of(Get.context!).unfocus();
        var response = await http.get(
            Uri.parse(
                "$api/Users/CheckLogin?email=${username.text}&pass=${password.text}"),
            headers: {"accept": "text/plain"});
        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          savingData(responseBody);
        } else {
          AlertClass.snackbarwrongalert("24".tr);
          isloading.toggle();
          update();
        }
      }
    }
  }

  forgetpassword() => Get.toNamed(AppRouting.forgetpasswrod);
}

class Login extends StatelessWidget {
  const Login({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: Column(
              children: [
                // Image
                FadeInDown(
                  duration: duration,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(logo), fit: BoxFit.fill)),
                  ),
                ),
                Expanded(
                    child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(40))),
                        child: SingleChildScrollView(
                          // Validate textfiled is not empty
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              children: [
                                // login in text hint
                                FadeInUp(
                                  duration: duration,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: Text("0".tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
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
                                        textInputType:
                                            TextInputType.emailAddress,
                                        controller: controller.username,
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
                                        maxLines: 1,
                                        hide: controller.showpass.value,
                                        trailing: GestureDetector(
                                          onTap: () => controller.viewpass(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Icon(
                                              controller.showpass.value
                                                  ? CupertinoIcons
                                                      .eye_slash_fill
                                                  : Icons.remove_red_eye,
                                              size: Get.width / 17,
                                            ),
                                          ),
                                        ),
                                        controller: controller.password,
                                        hints: "2".tr,
                                        iconData: Icons.lock),
                                  ),
                                ),

                                // forget passwrod + signin
                                FadeInRight(
                                  duration: duration,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      spacing: 15,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              controller.forgetpassword(),
                                          child: Text(
                                            "3".tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => controller.rigester(),
                                          child: Text(
                                            "4".tr,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Check Login button
                                FadeInUp(
                                  duration: duration,
                                  child: Container(
                                    width: Get.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(55),
                                            animationDuration:
                                                const Duration(seconds: 3),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 15),
                                            shape: const StadiumBorder()),
                                        onPressed: () => controller.login(),
                                        child: controller.isloading.value
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15),
                                                    child: Text("5".tr,
                                                        style: Theme.of(
                                                                Get.context!)
                                                            .textTheme
                                                            .labelLarge),
                                                  )
                                                ],
                                              )
                                            : Text("6".tr,
                                                style: Theme.of(Get.context!)
                                                    .textTheme
                                                    .labelLarge)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )))
              ],
            ),
          );
        });
  }
}
