import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordController extends GetxController {
  RxBool isloading = false.obs;
  String forgetype = "0";
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  // Code to send otp in email
  rigester() async {
    if (formKey.currentState!.validate()) {
      isloading.toggle();
      update();
      if (isloading.value) {
        var response = await http.get(
            Uri.parse(
                "$api/Users/ForgetPasswrod?email=${email.text}&type=$forgetype"),
            headers: {"accept": "*/*"});
        if (response.statusCode == 200) {
          // // Code to go to auth page with data
          var responseBody = jsonDecode(response.body);
          Get.offAllNamed(
            AppRouting.forgetpasswrodauth,
            parameters: {
              'usertype': "${responseBody['usertype']}",
              'email': email.text,
              "authCode": "${responseBody['authCode']}",
              'id': "${responseBody['id']}",
              'forgetype': forgetype,
            },
          );
        } else {
          AlertClass.snackbarwrongalert(forgetype == "0" ? "71".tr : "72".tr);
          isloading.toggle();
          update();
        }
      }
    }
  }

  // code to go to login page
  login() {
    FocusScope.of(Get.context!).unfocus();
    Get.back();
  }
}

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ForgetPasswordController(),
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
                          // Forget Password text hint
                          FadeInUp(
                            duration: duration,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Text("3".tr,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                          ),

                          // Email selected
                          FadeInRight(
                            duration: duration,
                            child: RadioListTile(
                                value: "0",
                                groupValue: controller.forgetype,
                                title: Text("1".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                onChanged: (value) {
                                  controller.forgetype = "$value";
                                  controller.update();
                                }),
                          ),

                          // Phone selected
                          FadeInLeft(
                            duration: duration,
                            child: RadioListTile(
                                value: "1",
                                groupValue: controller.forgetype,
                                title: Text("16".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                onChanged: (value) {
                                  controller.forgetype = "$value";
                                  controller.update();
                                }),
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
                                  hints: controller.forgetype == "0"
                                      ? "1".tr
                                      : "16".tr,
                                  iconData: controller.forgetype == "0"
                                      ? Icons.email
                                      : Icons.phone),
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
                    Icons.arrow_back_ios_new_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              )
            ],
          ));
        });
  }
}
