import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/textfield.dart';

class AlertClass {
  static snackbarsuccessalert(String title) {
    Get.showSnackbar(
      GetSnackBar(
        isDismissible: true,
        messageText: Center(
            child: Text(title,
                style: Theme.of(Get.context!).textTheme.labelLarge)),
        snackStyle: SnackStyle.FLOATING,
        borderRadius: 20,
        backgroundColor: Theme.of(Get.context!).colorScheme.primary,
        margin: const EdgeInsets.all(25),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static snackbarwrongalert(String title) {
    Get.showSnackbar(
      GetSnackBar(
        isDismissible: true,
        messageText: Center(
            child: Text(title,
                style: Theme.of(Get.context!).textTheme.labelLarge)),
        snackStyle: SnackStyle.FLOATING,
        borderRadius: 20,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(25),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static deletealert(RxBool loadingsave, Function() onPresed) {
    return showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: .5, end: 1).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: .5, end: 1).animate(a1),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: Text(
                "38".tr,
                style: Theme.of(Get.context!).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width / 3.7,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: onPresed,
                        child: loadingsave.value
                            ? CircularProgressIndicator(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)
                            : Text("37".tr,
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .labelLarge)),
                  ),
                  Container(
                    width: Get.width / 3.7,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: () => Get.back(),
                        child: Text("34".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static opertationalert(RxBool loadingsave, Function()? onPressed,
      TextEditingController dscrp, String hint) {
    return showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "",
      pageBuilder: (context, animation, secondaryAnimation) => Container(),
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: .5, end: 1).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: .5, end: 1).animate(a1),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: CustomTextField(hints: hint, controller: dscrp),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: Get.width / 3.7,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: onPressed,
                        child: loadingsave.value
                            ? CircularProgressIndicator(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)
                            : Text("33".tr,
                                style: Theme.of(Get.context!)
                                    .textTheme
                                    .labelLarge)),
                  ),
                  Container(
                    width: Get.width / 3.7,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size.fromHeight(55),
                            animationDuration: const Duration(seconds: 3),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            shape: const StadiumBorder()),
                        onPressed: () {
                          dscrp.clear();
                          Get.back();
                        },
                        child: Text("34".tr,
                            style:
                                Theme.of(Get.context!).textTheme.labelLarge)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static bootomsheet(Widget content) {
    return showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
      builder: (context) {
        return content;
      },
    );
  }

  static notificationsnackbar() {
    Get.showSnackbar(
      GetSnackBar(
        isDismissible: true,
        messageText: Center(
            child: Text("notiffication".tr,
                style: Theme.of(Get.context!).textTheme.labelLarge)),
        onTap: (snack) => Get.toNamed(AppRouting.notification),
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        borderRadius: 20,
        backgroundColor: Theme.of(Get.context!).colorScheme.primary,
        margin: const EdgeInsets.all(25),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
