import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:testing/Modules/admininfo.dart';
import 'package:testing/Modules/dropdown.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/customloading.dart';
import 'package:testing/UI/customnodata.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';
import 'package:testing/services/services.dart';

class AdminAccountController extends GetxController {
  MyServices myServices = Get.put(MyServices());
  RxList<AdminInfoModel> admininfoList = <AdminInfoModel>[].obs;
  int id = 0;
  final formKey = GlobalKey<FormState>();
  RxBool isloading = true.obs, loadingsave = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController personid = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController departtype = TextEditingController();
  TextEditingController worklocation = TextEditingController();
  TextEditingController workopen = TextEditingController();
  TextEditingController workclose = TextEditingController();
  TextEditingController workdays = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController dscrp = TextEditingController();
  File? adminImg;
  String departid = "48".tr, image = "";
  // specializations dropdown
  List<DropdownItem> dropdownUserType = [];
  @override
  void onInit() {
    id = myServices.sharedPreferences.getInt("ID") ?? 0;
    getAdminInfo();
    getspecializations();
    super.onInit();
  }

  // code to get  specializations
  getspecializations() async {
    var response = await http.get(Uri.parse("$api/Department/AllDepart"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        dropdownUserType.add(DropdownItem(item['id'], item['dscrp']));
      }
      update();
    }
  }

  // code to upload image
  pickAdminImg() async {
    FocusScope.of(Get.context!).unfocus();
    var result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result == null) return;
    adminImg = File(result.path);
    update();
  }

  // code to fetch admin info
  getAdminInfo() async {
    var response = await http.get(
        Uri.parse("$api/AdminInfo/AdminInfo?userid=$id"),
        headers: {"accept": "text/plain"});
    if (response.statusCode == 200) {
      isloading.toggle();

      var responseBody = jsonDecode(response.body);
      List<dynamic> jsonList = responseBody;
      List<AdminInfoModel> infoList =
          jsonList.map((json) => AdminInfoModel.fromJson(json)).toList();
      admininfoList.assignAll(infoList);
      name.text = "${admininfoList[0].name}";
      address.text = "${admininfoList[0].address}";
      departtype.text = "${admininfoList[0].departid}";
      worklocation.text = "${admininfoList[0].worklocation}";
      workopen.text = "${admininfoList[0].workopen}";
      workclose.text = "${admininfoList[0].workclose}";
      workdays.text = "${admininfoList[0].workdays}";
      phone.text = "${admininfoList[0].phone}";
      dscrp.text = "${admininfoList[0].dscrp}";
      image = "${admininfoList[0].image}";
      update();
    }
  }

  // code to save operation into database
  save() async {
    if (formKey.currentState!.validate()) {
      loadingsave.toggle();
      update();
      if (loadingsave.value == true) {
        var url = Uri.parse('$api/AdminInfo/Update');
        var request = http.MultipartRequest("PUT", url);
        request.fields["id"] = "0";
        request.fields["name"] = name.text;
        request.fields["address"] = address.text;
        request.fields["userid"] = "$id";
        request.fields["PersonID"] = personid.text;
        request.fields["departid"] = departtype.text;
        request.fields["worklocation"] = worklocation.text;
        request.fields["workopen"] = workopen.text;
        request.fields["workclose"] = workclose.text;
        request.fields["workdays"] = workdays.text;
        request.fields["phone"] = phone.text;
        request.fields["dscrp"] = dscrp.text;
        request.fields["image"] = "";
        if (adminImg != null) {
          var file =
              await http.MultipartFile.fromPath("adminImg", adminImg!.path);
          request.files.add(file);
        }
        var response = await request.send();
        if (response.statusCode == 200) {
          loadingsave.toggle();
          update();
          AlertClass.snackbarsuccessalert("29".tr);
        }
      }
    }
  }
}

class AdminAccount extends StatelessWidget {
  const AdminAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AdminAccountController(),
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
                // admin personal account setting
                title: Text(
                  "Settting0".tr,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              body: Obx(() {
                // if data is loading
                if (controller.isloading.value &&
                    controller.admininfoList.isEmpty) {
                  return const Center(child: CustomLoading());
                }
                // if data is empty
                else if (controller.isloading.value == false &&
                    controller.admininfoList.isEmpty) {
                  return const Center(child: CustomNoData());
                } else {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      // code to validate textfield
                      key: controller.formKey,
                      child: Column(
                        children: [
                          controller.image.isNotEmpty &&
                                  controller.adminImg == null
                              ? Stack(
                                  children: [
                                    // personal image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(150),
                                      child: CachedNetworkImage(
                                        height: 120,
                                        httpHeaders: const {"accept": "*/*"},
                                        width: 120,
                                        fit: BoxFit.fill,
                                        imageUrl:
                                            "$api/AdminInfo/GetImg?filename=${controller.image}",
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress)),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(logo),
                                                  fit: BoxFit.fill)),
                                        ),
                                      ),
                                    ),
                                    // upload image buton
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () => controller.pickAdminImg(),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              border: Border.all(
                                                  width: 4,
                                                  color: Theme.of(context)
                                                      .scaffoldBackgroundColor)),
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            size: Get.width / 22,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : controller.image.isEmpty &&
                                      controller.adminImg != null
                                  ? Stack(
                                      children: [
                                        //  image from device
                                        Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              image: DecorationImage(
                                                  image: FileImage(
                                                      controller.adminImg!),
                                                  fit: BoxFit.fill)),
                                        ),
                                        // upload image buton
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.pickAdminImg(),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor)),
                                              child: Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                size: Get.width / 22,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              border: Border.all(
                                                  width: 1.5,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary)),
                                          child: Icon(
                                            Icons.image,
                                            size: Get.width / 6,
                                          ),
                                        ),
                                        // upload image buton
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.pickAdminImg(),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  border: Border.all(
                                                      width: 4,
                                                      color: Theme.of(context)
                                                          .scaffoldBackgroundColor)),
                                              child: Icon(
                                                Icons.edit,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                size: Get.width / 22,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), // name text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.text,
                                  controller: controller.name,
                                  hints: "11".tr),
                            ),
                          ),

                          // name text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.text,
                                  controller: controller.personid,
                                  hints: "70".tr),
                            ),
                          ),

                          // address text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.streetAddress,
                                  controller: controller.address,
                                  hints: "15".tr),
                            ),
                          ),
                          // work location text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  controller: controller.worklocation,
                                  hints: "43".tr),
                            ),
                          ),

                          // work open text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  controller: controller.workopen,
                                  hints: "44".tr),
                            ),
                          ),

                          // work close text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  controller: controller.workclose,
                                  hints: "45".tr),
                            ),
                          ),

                          // work days text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: true,
                                  textInputType: TextInputType.text,
                                  controller: controller.workdays,
                                  hints: "46".tr),
                            ),
                          ),

                          // specialization dropdown
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Material(
                                elevation: 6,
                                shadowColor:
                                    Theme.of(Get.context!).colorScheme.primary,
                                borderRadius: BorderRadius.circular(30),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    isExpanded: true,
                                    iconEnabledColor: Theme.of(Get.context!)
                                        .colorScheme
                                        .primary,
                                    iconDisabledColor: Theme.of(Get.context!)
                                        .colorScheme
                                        .primary,
                                    hint: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(controller.departid,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .headlineSmall),
                                    ),
                                    onChanged: (value) {
                                      controller.departid = value!;
                                      controller.update();
                                    },
                                    items: controller.dropdownUserType
                                        .map<DropdownMenuItem<String>>(
                                            (value) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  controller.departtype.text =
                                                      "${value.value}";
                                                  controller.update();
                                                },
                                                value: value.label,
                                                alignment: Alignment.center,
                                                child: Center(
                                                  child: Text(value.label,
                                                      style:
                                                          Theme.of(Get.context!)
                                                              .textTheme
                                                              .headlineSmall),
                                                )))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // dscrp text field
                          FadeInDown(
                            duration: duration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: CustomTextField(
                                  validate: false,
                                  controller: controller.dscrp,
                                  hints: "47".tr),
                            ),
                          ),

                          // save button
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
                                  onPressed: () => controller.save(),
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
                                                  style: Theme.of(Get.context!)
                                                      .textTheme
                                                      .labelLarge),
                                            )
                                          ],
                                        )
                                      : Text("33".tr,
                                          style: Theme.of(Get.context!)
                                              .textTheme
                                              .labelLarge)),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              }));
        });
  }
}
