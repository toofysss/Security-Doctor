import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/UI/alert.dart';

class FirebaseApi {
  final firebasemessaging = FirebaseMessaging.instance;

  handelemessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        AlertClass.notificationsnackbar();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        Get.toNamed(AppRouting.notification);
      }
    });
  }

  Future<void> inittoken() async {
    await firebasemessaging.requestPermission();
    await firebasemessaging.getToken();
    await FirebaseMessaging.instance.subscribeToTopic("28");
    handelemessage();
  }
}
