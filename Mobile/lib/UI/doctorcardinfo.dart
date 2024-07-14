import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/userhome.dart';
import 'package:testing/UI/alert.dart';
import 'package:testing/constant/root.dart';
import 'package:http/http.dart' as http;
import 'package:testing/services/services.dart';

class DoctorCardController extends GetxController {
  MyServices myServices = Get.put(MyServices());
  RxBool isLoading = false.obs;
  int paiteintid = 0;
  DateTime now = DateTime.now();
  @override
  void onInit() {
    paiteintid = myServices.sharedPreferences.getInt("ID") ?? 0;
    super.onInit();
  }

  appointmentBooking(int id) async {
    isLoading.toggle();
    update();

    if (isLoading.value == true) {
      FocusScope.of(Get.context!).unfocus();
      Map<String, dynamic> data = {
        "id": 0,
        "patientid": paiteintid,
        "usertypeid": 1,
        "adminid": id,
        "status": 0,
        "opendate": '${now.year}/${now.month}/${now.day}',
        "closedate": ""
      };
      var response = await http.post(Uri.parse("$api/Schedule/Insert"),
          body: jsonEncode(data),
          headers: {
            "accept": " text/plain",
            "Content-Type": "application/json"
          });
      if (response.statusCode == 200) {
        isLoading.toggle();
        update();
        Get.forceAppUpdate();
        AlertClass.snackbarsuccessalert("29".tr);
      }
    }
  }

  showData(Admininfo data) {
    return showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    height: 150,
                    width: 150,
                    fit: BoxFit.fill,
                    imageUrl: "$api/AdminInfo/GetImg?filename=${data.image!}",
                    httpHeaders: const {"accept": "*/*"},
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(logo),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Text(
                    "${"49".tr} : ${data.name}",
                    style: Theme.of(context).textTheme.titleSmall,
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "${"Administrator0".tr} : ${data.depart}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "${"43".tr} : ${data.worklocation}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "${"44".tr} : ${data.workopen}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "${"45".tr} : ${data.workclose}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Text(
                  "${"46".tr} : ${data.workdays}",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Visibility(
                visible: data.dscrp!.isNotEmpty,
                child: SingleChildScrollView(
                  child: Container(
                    width: Get.width,
                    height: 200,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            width: 1.5,
                            color: Theme.of(context).colorScheme.primary)),
                    child: Text(
                      "${data.dscrp}",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ),
              Container(
                width: Get.width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(55),
                        animationDuration: const Duration(seconds: 3),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        shape: const StadiumBorder()),
                    onPressed: () => appointmentBooking(data.id!),
                    child: isLoading.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Text("5".tr,
                                    style: Theme.of(Get.context!)
                                        .textTheme
                                        .labelLarge),
                              )
                            ],
                          )
                        : Text("51".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
              )
            ],
          ),
        );
      },
    );
  }
}

class DoctorCardInfo extends StatelessWidget {
  final Admininfo item;
  const DoctorCardInfo({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DoctorCardController(),
        builder: (controller) {
          return GestureDetector(
            onTap: () => controller.showData(item),
            child: Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: CachedNetworkImageProvider(
                            "$api/AdminInfo/GetImg?filename=${item.image!}"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "${item.name}",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        "${item.depart}",
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
