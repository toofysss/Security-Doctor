import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/constant/root.dart';

class OnBoardingController extends GetxController {
  // Go to login page
  login() {
    FocusScope.of(Get.context!).unfocus();
    Get.offAllNamed(AppRouting.login);
  }
}

class OnBoarding extends StatelessWidget {
  const OnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OnBoardingController(),
        builder: (controller) {
          return Scaffold(
              body: SafeArea(
                  child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  FadeInDown(
                    duration: duration,
                    child: Lottie.asset(
                      onBoardingImg,
                      height: 250,
                      repeat: true,
                      fit: BoxFit.fill,
                    ),
                  ),
                  // Title
                  FadeInRight(
                    duration: duration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("BoardingTitle0".tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                  // Subtitle
                  FadeInLeft(
                    duration: duration,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("BoardingSubtitle0".tr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ),
                  // Button
                  FadeInUp(
                    duration: duration,
                    child: Container(
                      width: Get.width,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 60),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(55),
                              animationDuration: const Duration(seconds: 3),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              shape: const StadiumBorder()),
                          onPressed: () => controller.login(),
                          child: Text("23".tr,
                              style:
                                  Theme.of(Get.context!).textTheme.labelLarge)),
                    ),
                  )
                ],
              ),
            ),
          )));
        });
  }
}
