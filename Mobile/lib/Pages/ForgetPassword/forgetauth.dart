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

class ForgetAuthController extends GetxController {
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
  authintication(String usertype, String id) async {
    Get.offAllNamed(
      AppRouting.forgetChangePass,
      parameters: {'usertype': usertype, 'id': id},
    );
  }

  // code to resend email
  resendemail(String email, forgetype) async {
    authpassword.clear();
    isloading.value = true;
    stopTimer();
    startTimer();
    update();
    var response = await http.get(
        Uri.parse("$api/Users/ForgetPasswrod?email=$email&type=$forgetype"),
        headers: {"accept": "*/*"});
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      authCode = "${responseBody['authCode']}";
      update();
    }
  }

  // code to auth the otp password with opt enter
  validate(String code, email, usertype, id) {
    authCode.isEmpty ? authCode = code : authCode = authCode;
    if (authpassword.text != authCode) {
      return "12".tr;
    } else {
      authintication(usertype, id);
      return null;
    }
  }
}

class ForgetAuth extends StatelessWidget {
  final String authauthPassword, email, usertype, forgetype, id;
  const ForgetAuth(
      {required this.email,
      required this.authauthPassword,
      required this.usertype,
      required this.forgetype,
      required this.id,
      super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ForgetAuthController(),
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //  otp textfield
                  FadeInDown(
                    duration: duration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Pinput(
                        validator: (value) => controller.validate(
                            authauthPassword, email, usertype, id),
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
                                  color: Theme.of(context).colorScheme.primary)
                            ],
                            border: Border.all(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),

                      // otp resend button
                      FadeInRight(
                        duration: duration,
                        child: Container(
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(55),
                                animationDuration: const Duration(seconds: 3),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () =>
                                  controller.isloading.value == false
                                      ? controller.resendemail(email, forgetype)
                                      : null,
                              child: controller.isloading.value
                                  ? Text(
                                      controller
                                          .strFormatting(controller.resendTime),
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
            ],
          ));
        });
  }
}
