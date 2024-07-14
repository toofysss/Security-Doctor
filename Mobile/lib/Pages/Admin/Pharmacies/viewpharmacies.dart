import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/operation.dart';
import 'package:http/http.dart' as http;
import 'package:testing/Pages/Admin/Pharmacies/pharmacies.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/constant/root.dart';

class ViewPharmaciesController extends GetxController {
  RxBool isloading = false.obs;
  PharmaciesController controller = Get.put(PharmaciesController());

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
      request.fields["answers"] = "";

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

class ViewPharmacies extends StatelessWidget {
  final OperationMoudle data;
  const ViewPharmacies({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ViewPharmaciesController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              // Back button
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
              // name of paitent
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
                    child: Text("Pharmacies1".tr,
                        style: Theme.of(context).textTheme.headlineSmall),
                  ),
                  // View Doctor Hint
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
                  // Save Button
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
