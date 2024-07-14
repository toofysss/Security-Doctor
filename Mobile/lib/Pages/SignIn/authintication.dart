import 'dart:async';
import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/constant/root.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthinticationController extends GetxController {
  MyServices myServices = Get.put(MyServices());

  RxBool showpass = true.obs, isloading = true.obs;
  int resendTime = 0;
  late Timer countdownTimer;
  String authCode = "";
  TextEditingController authpassword = TextEditingController();
  String strFormatting(n) => n.toString().padLeft(2, '0');

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  // code to start timer to resend email otp auth
  startTimer() {
    resendTime = 30;
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      resendTime = resendTime - 1;

      update();
      if (resendTime < 1) {
        isloading.value = false;
        countdownTimer.cancel();
        update();
      }
    });
  }

  stopTimer() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  // code to set operation auth otp
  authintication(
      String email, String password, String name, String usertype) async {
    FocusScope.of(Get.context!).unfocus();
    Map<String, dynamic> data = {
      "id": 0,
      "email": email,
      "password": password,
      "usertype": usertype
    };
    var response = await http.post(
      Uri.parse("$api/Users/Insert"),
      headers: {"accept": "*/*", "Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      myServices.sharedPreferences.setString("login", responseBody['name']);
      myServices.sharedPreferences.setInt("ID", responseBody['id']);
      myServices.sharedPreferences.setInt("usertype", responseBody['usertype']);
      if (responseBody['name'] == "User") {
        await FirebaseMessaging.instance
            .subscribeToTopic("${responseBody['id']}");
        Get.offAllNamed(AppRouting.home);
      } else if (responseBody['name'] == "admin") {
        Get.offAllNamed(AppRouting.administrator);
      } else {
        Get.offAllNamed(AppRouting.admin);
      }
    }

    update();
  }

  // code to resend email
  resendemail(String email) async {
    authpassword.clear();
    isloading.value = true;
    stopTimer();
    startTimer();
    update();
    var response = await http.get(Uri.parse("$api/Users/SendMail?Email=$email"),
        headers: {"accept": "*/*"});
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      authCode = "$responseBody";
      update();
    }
  }

  // code to auth the otp password with opt enter
  validate(String code, email, password, name, usertype) {
    authCode.isEmpty ? authCode = code : authCode = authCode;
    if (authpassword.text != authCode) {
      return "12".tr;
    } else {
      authintication(email, password, name, usertype);
      return null;
    }
  }
}

class AuthinticationPage extends StatelessWidget {
  final String authauthPassword, email, name, password, usertype;
  const AuthinticationPage(
      {required this.email,
      required this.authauthPassword,
      required this.password,
      this.name = "",
      required this.usertype,
      super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthinticationController(),
        builder: (controller) {
          return Scaffold(
              body: Column(
            children: [
              // image logo
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
                      top: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //  otp textfield
                      FadeInDown(
                        duration: duration,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Pinput(
                            validator: (value) => controller.validate(
                                authauthPassword,
                                email,
                                password,
                                name,
                                usertype),
                            controller: controller.authpassword,
                            length: 6,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            defaultPinTheme: PinTheme(
                              height: 60.0,
                              width: 60.0,
                              textStyle: Theme.of(context).textTheme.labelLarge,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Theme.of(context).colorScheme.primary)
                                ],
                                border: Border.all(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // hint to resend email
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text("9".tr,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),

                          // otp resend button
                          FadeInRight(
                            duration: duration,
                            child: Container(
                              width: Get.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(55),
                                    animationDuration:
                                        const Duration(seconds: 3),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    shape: const StadiumBorder(),
                                  ),
                                  onPressed: () =>
                                      controller.isloading.value == false
                                          ? controller.resendemail(email)
                                          : null,
                                  child: controller.isloading.value
                                      ? Text(
                                          controller.strFormatting(
                                              controller.resendTime),
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .labelLarge)
                                      : Text("10".tr,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .labelLarge)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ));
        });
  }
}
