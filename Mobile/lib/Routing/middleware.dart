import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/services.dart';
import 'approuting.dart';

class Middleware extends GetMiddleware {
  MyServices myServices = Get.put(MyServices());
  @override
  int? get priority => 1;
  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is admin
    if (myServices.sharedPreferences.getString("login") == "admin") {
      return RouteSettings(name: AppRouting.administrator);

      // Check if the user is User
    } else if (myServices.sharedPreferences.getString("login") == "User") {
      return RouteSettings(name: AppRouting.home);

      // Check if the user is admin (doctor or like that)
    } else if (myServices.sharedPreferences.getString("login") != null) {
      return RouteSettings(name: AppRouting.admin);
    }
    return null;
  }
}
