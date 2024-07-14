import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/userhome.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/doctorcardinfo.dart';
import 'package:testing/UI/textfield.dart';

class ViewspecializationsController extends GetxController {
  TextEditingController search = TextEditingController();
  RxList<Admininfo> filteredAdminInfo = RxList<Admininfo>();
  UserHomeModule data;
  ViewspecializationsController(this.data);

  @override
  void onInit() {
    filteredAdminInfo.assignAll(data.admininfo!);
    super.onInit();
  }

  // Filter Data
  void filterAdminInfo(String query) {
    filteredAdminInfo.assignAll(data.admininfo!
        .where(
            (admin) => admin.name!.toLowerCase().contains(query.toLowerCase()))
        .toList());
  }
}

class Viewspecializations extends StatelessWidget {
  final UserHomeModule data;
  const Viewspecializations({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ViewspecializationsController(data),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                // Back Button
                leading: IconButton(
                  highlightColor:
                      Theme.of(context).colorScheme.primary.withOpacity(.1),
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: Get.width / 18,
                  ),
                ),
                // Name Of Specializations
                title: Text(data.dscrp!,
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // Text Field To Filter Data
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: CustomTextField(
                        onChange: (value) => controller.filterAdminInfo(value),
                        controller: controller.search,
                        hints: "26".tr,
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    Obx(() {
                      // If Data Is Empty
                      if (controller.filteredAdminInfo.isEmpty) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: CustomNoData(),
                        ));
                      } else {
                        // Display Data Like Grid 2 or >
                        return GridView.builder(
                            itemCount: controller.filteredAdminInfo.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    mainAxisExtent: 220,
                                    crossAxisSpacing: 10),
                            itemBuilder: (_, index) {
                              // Design of Doctor Card
                              return DoctorCardInfo(
                                  item: controller.filteredAdminInfo[index]);
                            });
                      }
                    }),
                  ],
                ),
              ));
        });
  }
}
