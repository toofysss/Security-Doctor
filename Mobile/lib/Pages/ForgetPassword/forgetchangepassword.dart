import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:http/http.dart' as http;

class ForgetChangePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool isloading = true.obs, loadingsave = false.obs;

  TextEditingController confPassword = TextEditingController();
  TextEditingController password = TextEditingController();

  // code to change password
  changepass(String id, String usertype) async {
    if (password.text == confPassword.text) {
      loadingsave.toggle();
      update();
      if (loadingsave.value) {
        var response = await http.put(
            Uri.parse(
                "$api/Users/UpdatePasswordUser?id=$id&password=${password.text}"),
            headers: {"accept": "text/plain"});
        if (response.statusCode == 200) {
          // check if user  is user
          if (usertype == "4") {
            Get.offAllNamed(AppRouting.home);
          }
          // check if user  is administrator
          else if (usertype == "5") {
            Get.offAllNamed(AppRouting.administrator);
          }
          // check if user  is admin
          else {
            Get.offAllNamed(AppRouting.admin);
          }
        }
      }
    }
  }
}

class ForgetChangePassword extends StatelessWidget {
  final String id;
  final String usertype;
  const ForgetChangePassword(
      {required this.id, required this.usertype, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ForgetChangePasswordController(),
        builder: (controller) {
          return Scaffold(
            body: // logo image
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
                            margin: const EdgeInsets.symmetric(vertical: 25),
                            child: Text("30".tr,
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
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
                                onPressed: () =>
                                    controller.changepass(id, usertype),
                                child: controller.loadingsave.value
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .scaffoldBackgroundColor),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Text("5".tr,
                                                style: Theme.of(Get.context!)
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
          );
        });
  }
}
