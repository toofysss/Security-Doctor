import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/homeitem.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/homecard.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';

class AdminController extends GetxController {
  MyServices myServices = Get.put(MyServices());
  int usertype = 0;
  bool startAnimation = false;

  Size size = MediaQuery.of(Get.context!).size;
  List<HomeModule> data = [];
  final theme = Theme.of(Get.context!);

  @override
  void onInit() {
    usertype = myServices.sharedPreferences.getInt("usertype") ?? 0;
    data = [
      HomeModule(
          icon: FontAwesomeIcons.userDoctor,
          onTap: () {
            if (usertype == 1) {
              Get.toNamed(AppRouting.doctor);
            } else {
              AlertClass.snackbarwrongalert("61".tr);
            }
          },
          endcolor: const Color.fromARGB(255, 9, 66, 99),
          startcolor: const Color(0xff418EBA)),
      HomeModule(
          icon: FontAwesomeIcons.flask,
          onTap: () {
            if (usertype == 2) {
              Get.toNamed(AppRouting.laboratories);
            } else {
              AlertClass.snackbarwrongalert("61".tr);
            }
          },
          endcolor: const Color.fromARGB(255, 25, 92, 97),
          startcolor: const Color(0xff00CCA7)),
      HomeModule(
          onTap: () {
            if (usertype == 3) {
              Get.toNamed(AppRouting.pharmacies);
            } else {
              AlertClass.snackbarwrongalert("61".tr);
            }
          },
          icon: FontAwesomeIcons.capsules,
          endcolor: const Color.fromARGB(255, 206, 43, 43),
          startcolor: const Color.fromARGB(255, 136, 15, 6)),
    ];
    animation();
    super.onInit();
  }

  setting() {
    Get.toNamed(AppRouting.setting);
  }

  animation() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startAnimation = true;
      update();
    });
  }
}

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdminController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: 60,
                title: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(logo),
                  radius: 25,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () => controller.setting(),
                        icon: Icon(
                          Icons.grid_view_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  )
                ],
              ),
              body: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: controller.data.length,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 170,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 15),
                  itemBuilder: (context, index) {
                    var item = controller.data[index];
                    return AnimatedContainer(
                      curve: Curves.fastOutSlowIn,
                      duration: Duration(milliseconds: 300 + (index * 200)),
                      transform: Matrix4.translationValues(
                          0, controller.startAnimation ? 0 : Get.width, 0),
                      child: HomeCard(
                        homeModule: item,
                        title: 'Admin$index'.tr,
                      ),
                    );
                  }));
        });
  }
}
