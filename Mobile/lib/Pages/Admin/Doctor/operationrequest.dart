import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/dropdown.dart';
import 'package:testing/Modules/schedule.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:http/http.dart' as http;

class OperationRequestController extends GetxController {
  String usertype = '0', userValue = "69".tr;

  TextEditingController notes = TextEditingController();
  TextEditingController usertypes = TextEditingController();
  TextEditingController userID = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isloading = true.obs, loadingsave = false.obs;

  OperationRequestController(this.usertype);
  // data dropdown
  List<DropdownItem> dropdownData = [];
  // code to get  data
  getData() async {
    var response = await http.get(
        Uri.parse("$api/AdminInfo/byType?usertype=$usertype"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        dropdownData.add(DropdownItem(item['id'], item['dscrp']));
      }
      isloading.toggle();
      update();
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

// Code To set Operation
  operation(int scheduleid, int adminid) async {
    if (formKey.currentState!.validate() && userID.text.isNotEmpty) {
      loadingsave.toggle();
      update();
      if (loadingsave.value) {
        Map<String, dynamic> data = {
          "id": 0,
          "scheduleid": scheduleid,
          "adminid": userID,
          "usertypeid": usertype,
          "status": 0,
          "notes": notes.text,
          "answers": ""
        };
        var response = await http.post(Uri.parse("$api/Operation/Insert"),
            headers: {
              "accept": "text/plain",
              "Content-Type": "application/json"
            },
            body: jsonEncode(data));
        if (response.statusCode == 200) {
          AlertClass.snackbarsuccessalert("29".tr);

          loadingsave.toggle();
          update();
        }
      }
    } else {
      AlertClass.snackbarwrongalert("22".tr);
    }
  }
}

class OperationRequest extends StatelessWidget {
  final String usertype;
  final String title;
  final ScheduleModule data;
  const OperationRequest(
      {required this.usertype,
      required this.title,
      required this.data,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OperationRequestController(usertype),
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
                  ),
                ),
                centerTitle: true,
                // doctor title
                title:
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
              ),
              body: Obx(() {
                if (controller.isloading.value &&
                    controller.dropdownData.isEmpty) {
                  return const Center(child: CustomLoading());
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Paitent Hint
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Text(
                                "67".tr,
                                style: Theme.of(context).textTheme.titleSmall,
                              )),

                          // Paitent Name
                          Container(
                            width: Get.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
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
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: Text(
                              data.patientInfo!.name!,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),

                          // Choice UserType
                          Container(
                            width: Get.width,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            child: Material(
                              surfaceTintColor: Colors.transparent,
                              elevation: 6,
                              shadowColor:
                                  Theme.of(Get.context!).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Text(controller.userValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                  items: controller.dropdownData
                                      .map((item) => DropdownMenuItem(
                                            onTap: () {
                                              controller.userID.text =
                                                  "${item.value}";
                                              controller.update();
                                            },
                                            value: item.label,
                                            child: Text(
                                              item.label,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall,
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    controller.userValue = value!;
                                    controller.update();
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 200),
                                  dropdownStyleData: const DropdownStyleData(
                                      maxHeight: 200,
                                      offset: Offset(0, -10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)))),
                                  menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      overlayColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  dropdownSearchData: DropdownSearchData(
                                    searchController: controller.usertypes,
                                    searchInnerWidgetHeight: 50,
                                    searchInnerWidget: Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 4, right: 8, left: 8),
                                      child: TextFormField(
                                        expands: true,
                                        maxLines: null,
                                        controller: controller.usertypes,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 8),
                                          hintText: '26'.tr,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    searchMatchFn: (item, searchValue) {
                                      return item.value
                                          .toString()
                                          .contains(searchValue);
                                    },
                                  ),
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      controller.usertypes.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          // Notes
                          CustomTextField(
                              validate: true,
                              controller: controller.notes,
                              hints: "68".tr),
                          // Save Operation Button
                          Container(
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
                                onPressed: () => controller.operation(
                                    data.id!, data.adminInfo!.id!),
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
                                    : Text("37".tr,
                                        style: Theme.of(Get.context!)
                                            .textTheme
                                            .labelLarge)),
                          ),
                        ],
                      )),
                );
              }));
        });
  }
}
