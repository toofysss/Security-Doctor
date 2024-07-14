import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/userhome.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/doctorcardinfo.dart';
import 'package:testing/constant/root.dart';
import 'package:http/http.dart' as http;

class UserHomeController extends GetxController {
  TextEditingController search = TextEditingController();
  RxBool isLoading = true.obs;
  RxList<UserHomeModule> homeData = <UserHomeModule>[].obs;

  @override
  void onInit() {
    getHomeData();
    super.onInit();
  }

  // Get Doctor and specialization Data
  Future<void> getHomeData() async {
    final response =
        await http.get(Uri.parse("$api/Department/All?usertype=1"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<UserHomeModule> data =
          jsonResponse.map((json) => UserHomeModule.fromJson(json)).toList();
      homeData.assignAll(data);
      isLoading.toggle();
      update();
    }
  }

  // Go to  Specializations Page
  viewSpecializations(UserHomeModule item) =>
      Get.toNamed(AppRouting.viewspecializations, arguments: item);
}

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserHomeController>(
      init: UserHomeController(),
      builder: (controller) {
        return Obx(() {
          // if Specializations is loading
          if (controller.isLoading.value && controller.homeData.isEmpty) {
            return const Center(child: CustomLoading());
          }
          // if Specializations is empty
          else if (!controller.isLoading.value && controller.homeData.isEmpty) {
            return const Center(child: CustomNoData());
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specializations
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.homeData.length,
                      itemBuilder: (_, index) {
                        final item = controller.homeData[index];
                        return Visibility(
                          visible: item.admininfo!.isNotEmpty,
                          child: GestureDetector(
                            onTap: () => controller.viewSpecializations(item),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.25),
                                    blurRadius: 28,
                                    offset: Offset(0, 14),
                                  ),
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.22),
                                    blurRadius: 10,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Text(
                                item.dscrp!,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Specializations + Doctor Card (Scroll horizontal)
                  SizedBox(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shrinkWrap: true,
                      itemCount: controller.homeData.length,
                      itemBuilder: (_, index) {
                        final item = controller.homeData[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: item.admininfo!.isNotEmpty,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  item.dscrp!,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: item.admininfo!.isNotEmpty,
                              child: SizedBox(
                                height: 270,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: item.admininfo!.length > 10
                                        ? 10
                                        : item.admininfo!.length,
                                    itemBuilder: (_, index) {
                                      var data = item.admininfo![index];
                                      return Container(
                                          width: 190,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 10),
                                          child: DoctorCardInfo(item: data));
                                    }),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
      },
    );
  }
}
