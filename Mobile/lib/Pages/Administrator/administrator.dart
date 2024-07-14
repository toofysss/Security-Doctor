import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/homeitem.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/homecard.dart';
import 'package:testing/constant/root.dart';

class AdministratorController extends GetxController {
  setting() {
    Get.toNamed(AppRouting.setting);
  }

  List<HomeModule> data = [
    HomeModule(
         icon: FontAwesomeIcons.stethoscope,
        onTap: () => Get.toNamed(AppRouting.specializations),
        endcolor: const Color.fromARGB(255, 9, 66, 99),
        startcolor: const Color(0xff418EBA)),
    HomeModule(
         icon: FontAwesomeIcons.userDoctor,
        onTap: () => Get.toNamed(AppRouting.users),
        endcolor: const Color.fromARGB(255, 25, 92, 97),
        startcolor: const Color(0xff00CCA7)),
    HomeModule(
         icon: Icons.person_2_sharp,
        onTap: () => Get.toNamed(AppRouting.usersType),
        endcolor: const Color.fromARGB(255, 206, 43, 43),
        startcolor: const Color.fromARGB(255, 136, 15, 6)),
    HomeModule(
         icon: FontAwesomeIcons.userGroup,
        onTap: () => Get.toNamed(AppRouting.profiles),
        endcolor: const Color.fromARGB(255, 9, 66, 99),
        startcolor: const Color(0xff418EBA)),
  ];
  bool isDark = true, startAnimation = false;

  @override
  void onInit() {
    animation();
    super.onInit();
  }

  animation() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      startAnimation = true;
      update();
    });
  }
}

class Administrator extends StatelessWidget {
  const Administrator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdministratorController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: 60,
                // logo image
                title: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(logo),
                  radius: 25,
                ),
                actions: [
                  // Setting button
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
              // Display data like grid 2 or >
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
                  itemBuilder: (context, index) => AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 300 + (index * 200)),
                        transform: Matrix4.translationValues(
                            0, controller.startAnimation ? 0 : Get.width, 0),
                        child:
                            // home admin card design
                            HomeCard(
                          homeModule: controller.data[index],
                          title: 'Administrator$index'.tr,
                        ),
                      )));
        });
  }
}
