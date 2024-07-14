import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';
import 'package:http/http.dart' as http;

class ChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isloading = true.obs, loadingsave = false.obs;
  MyServices myServices = Get.put(MyServices());
  int id = 0;
  @override
  void onInit() {
    id = myServices.sharedPreferences.getInt("ID") ?? 0;
    super.onInit();
  }

  TextEditingController confPassword = TextEditingController();
  TextEditingController password = TextEditingController();

  // go back to setting
  setting() => Get.back();

  // code to change password
  changepass() async {
    if (password.text == confPassword.text) {
      loadingsave.toggle();
      update();
      if (loadingsave.value) {
        var response = await http.put(
            Uri.parse(
                "$api/Users/UpdatePasswordUser?id=$id&password=${password.text}"),
            headers: {"accept": "text/plain"});
        if (response.statusCode == 200) {
          AlertClass.snackbarsuccessalert("29".tr);
          loadingsave.toggle();
          update();
        }
      }
    }
  }
}

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ChangePasswordController(),
        builder: (controller) {
          return Scaffold(
            body: Stack(
              children: [
                // logo image
                SingleChildScrollView(
                  child: Column(
                    children: [
                      FadeInDown(
                        duration: duration,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 40),
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(logo), fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            // change password title
                            FadeInUp(
                              duration: duration,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 25),
                                child: Text("30".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ),
                            ),

                            // password textfield
                            FadeInLeft(
                              duration: duration,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: CustomTextField(
                                    validate: true,
                                    controller: controller.password,
                                    hints: "31".tr,
                                    iconData: Icons.lock),
                              ),
                            ),

                            // re-enter password textfield
                            FadeInRight(
                              duration: duration,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: CustomTextField(
                                    validate: true,
                                    textInputType: TextInputType.emailAddress,
                                    controller: controller.confPassword,
                                    hints: "32".tr,
                                    iconData: Icons.lock),
                              ),
                            ),

                            // button Save
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
                                    onPressed: () => controller.changepass(),
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
                                                    style:
                                                        Theme.of(Get.context!)
                                                            .textTheme
                                                            .labelLarge),
                                              )
                                            ],
                                          )
                                        : Text("30".tr,
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
                // code to back to setting
                Positioned(
                    top: 10,
                    left: lang == "en" ? 10 : null,
                    right: lang == "ar" ? 10 : null,
                    child: IconButton(
                        onPressed: () => controller.setting(),
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )))
              ],
            ),
          );
        });
  }
}
