import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/setting.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';

class SettingAdminController extends GetxController {
  bool startAnimation = false;
  MyServices myServices = Get.put(MyServices());
  String loginData = "";
  List<SettingModel> settingitem = [];
  String login = "";
  @override
  void onInit() {
    loginData = myServices.sharedPreferences.getString("login") ?? "";
    print(loginData);
    settingitem = [
      // setting for user Personal account
      SettingModel(
        visible: loginData != "admin" && loginData == "User",
        iconData: Icons.person,
        onTap: () => Get.toNamed(AppRouting.useraccount),
      ),

      // setting for admin Personal account
      SettingModel(
        visible: loginData != "admin" && loginData != "User",
        iconData: Icons.person,
        onTap: () => Get.toNamed(AppRouting.adminaccount),
      ),
      // SettingModel(
      //     iconData: CupertinoIcons.moon_fill,
      //     onTap: () => showModalBottomSheet(
      //           context: Get.context!,
      //           shape: const RoundedRectangleBorder(
      //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      //           ),
      //           backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      //           builder: (context) {
      //             return Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 RadioListTile(
      //                   shape: const RoundedRectangleBorder(
      //                     borderRadius:
      //                         BorderRadius.vertical(top: Radius.circular(20)),
      //                   ),
      //                   title: Text("Theme0".tr,
      //                       style: Theme.of(context).textTheme.titleSmall),
      //                   activeColor: Theme.of(context).primaryColor,
      //                   value: "Mode",
      //                   groupValue: mode,
      //                   onChanged: (String? value) =>
      //                       changeMode(ThemeMode.system),
      //                 ),
      //                 RadioListTile(
      //                   title: Text("Theme1".tr,
      //                       style: Theme.of(context).textTheme.titleSmall),
      //                   activeColor: Theme.of(context).primaryColor,
      //                   value: "on",
      //                   groupValue: mode,
      //                   onChanged: (value) => changeMode(ThemeMode.dark),
      //                 ),
      //                 RadioListTile(
      //                   title: Text("Theme2".tr,
      //                       style: Theme.of(context).textTheme.titleSmall),
      //                   activeColor: Theme.of(context).primaryColor,
      //                   value: "off",
      //                   groupValue: mode,
      //                   onChanged: (value) => changeMode(ThemeMode.light),
      //                 ),
      //               ],
      //             );
      //           },
      //         ),
      //     title: "Settting1".tr),

      // setting for language
      SettingModel(
        iconData: Icons.language,
        onTap: () => AlertClass.bootomsheet(Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              title: Text("Lang2".tr,
                  style: Theme.of(Get.context!).textTheme.titleSmall),
              activeColor: Theme.of(Get.context!).primaryColor,
              value: "ar",
              groupValue: lang,
              onChanged: (String? value) => changeLang("ar"),
            ),
            RadioListTile(
              title: Text("Lang1".tr,
                  style: Theme.of(Get.context!).textTheme.titleSmall),
              activeColor: Theme.of(Get.context!).primaryColor,
              value: "en",
              groupValue: lang,
              onChanged: (value) => changeLang("en"),
            ),
          ],
        )),
      ),

      // setting for changepassword
      SettingModel(
        iconData: Icons.lock,
        onTap: () => Get.toNamed(AppRouting.changePass),
      ),

      // setting for logout
      SettingModel(
        iconData: Icons.logout_outlined,
        onTap: () {
          myServices.sharedPreferences.remove("login");
          myServices.sharedPreferences.remove("id");
          myServices.sharedPreferences.remove("usertype");
          Get.offNamed(AppRouting.login);
        },
      )
    ];
    animation();
    super.onInit();
  }

  // start animation
  animation() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startAnimation = true;
      update();
    });
  }

  // code to change language
  void changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    lang = langcode;
    Get.updateLocale(locale);
    update();
    Get.back();
  }

  // void changeMode(ThemeMode langcode) {
  //   themeMode = langcode;
  //   mode = themeMode == ThemeMode.system
  //       ? "Mode"
  //       : langcode == ThemeMode.dark
  //           ? "on"
  //           : "off";
  //   myServices.sharedPreferences.setString("Mode", mode);
  //   Get.back();
  //   Get.forceAppUpdate();
  // }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SettingAdminController(),
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
              title:
                  Text("25".tr, style: Theme.of(context).textTheme.titleSmall),
            ),
            body: ListView.builder(
                itemCount: controller.settingitem.length,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, index) {
                  var item = controller.settingitem[index];
                  // visible data where code
                  return Visibility(
                    visible: item.visible,
                    child: GestureDetector(
                      onTap: item.onTap,
                      // code to start animation to top
                      child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 300 + (index * 200)),
                        transform: Matrix4.translationValues(
                            0, controller.startAnimation ? 0 : Get.width, 0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 25),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.iconData,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  size: Get.width / 18,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "Settting$index".tr,
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              size: Get.width / 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        });
  }
}
