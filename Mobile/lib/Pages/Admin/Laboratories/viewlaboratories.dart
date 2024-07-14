import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/Modules/operation.dart';
import 'package:http/http.dart' as http;
import 'package:testing/Pages/Admin/Laboratories/laboratories.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/UI/textfield.dart';
import 'package:testing/constant/root.dart';

class ViewLaboratoriesController extends GetxController {
  RxBool isloading = false.obs;
  LaboratoriesController controller = Get.put(LaboratoriesController());
  TextEditingController result = TextEditingController();
  RxList<File> resultimage = <File>[].obs;

  // Code To Upload Image And Display It
  uploadimage(ImageSource source) async {
    resultimage.clear();
    List<XFile>? images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      for (var image in images) {
        resultimage.add(File(image.path));
      }
    }
    update();
  }

  // Code To Upload All Data In Database
  confirm(OperationMoudle data) async {
    isloading.toggle();
    update();
    if (isloading.value) {
      var url = Uri.parse('$api/Operation/Update');
      var request = http.MultipartRequest("PUT", url);
      request.fields["id"] = "${data.id}";
      request.fields["scheduleid"] = "${data.scheduleid}";
      request.fields["adminid"] = "${data.adminid}";
      request.fields["usertypeid"] = "${data.usertypeid}";
      request.fields["status"] = "1";
      request.fields["notes"] = "";
      request.fields["answers"] = result.text;
      if (resultimage.isNotEmpty) {
        for (var file in resultimage) {
          var multipartFile =
              await http.MultipartFile.fromPath('operationImg', file.path);
          request.files.add(multipartFile);
        }
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        controller.filtereddatalist
            .removeWhere((notification) => notification.id == data.id);
        isloading.toggle();
        update();
        AlertClass.snackbarsuccessalert("29".tr);
      }
    }
  }
}

class ViewLaboratories extends StatelessWidget {
  final OperationMoudle data;
  const ViewLaboratories({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ViewLaboratoriesController(),
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
              // Title Of Page
              title: Text("${data.patientInfo!.name}",
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor Hint
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text("Laboratories1".tr,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  //   View Doctor Hint
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
                        color: Theme.of(context).scaffoldBackgroundColor),
                    child: Text("${data.notes}",
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  // Result Hint
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text("Laboratories2".tr,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  // Text Filed To Write Result
                  CustomTextField(
                      controller: controller.result, hints: "Laboratories2".tr),
                  // List Uploaded Image
                  Visibility(
                    visible: controller.resultimage.isNotEmpty,
                    child: SizedBox(
                      height: 350,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.resultimage.length,
                          itemBuilder: (_, index) {
                            var item = controller.resultimage[index];
                            return Container(
                              width: 250,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: FileImage(item),
                                      fit: BoxFit.fill)),
                            );
                          }),
                    ),
                  ),
                  // Upload Image Button
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: () => AlertClass.bootomsheet(Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Camera Button
                                  GestureDetector(
                                    onTap: () => controller
                                        .uploadimage(ImageSource.camera),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Theme.of(Get.context!)
                                                  .iconTheme
                                                  .color!
                                                  .withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: Get.width / 16,
                                            ),
                                          ),
                                        ),
                                        Text("62".tr,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(Get.context!)
                                                .textTheme
                                                .headlineSmall)
                                      ],
                                    ),
                                  ),
                                  // Gallery Button
                                  GestureDetector(
                                    onTap: () => controller
                                        .uploadimage(ImageSource.gallery),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Theme.of(Get.context!)
                                                    .iconTheme
                                                    .color!
                                                    .withOpacity(0.2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.image,
                                                size: Get.width / 16,
                                              ),
                                            ),
                                          ),
                                          Text("63".tr,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(Get.context!)
                                                  .textTheme
                                                  .headlineSmall)
                                        ]),
                                  )
                                ],
                              ),
                            )),
                        child: Text("64".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
                  ),
                  // Save Button
                  Container(
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: () => controller.confirm(data),
                        child: controller.isloading.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                            : Text("33".tr,
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .labelLarge)),
                  )
                ],
              ),
            ),
          );
        });
  }
}
