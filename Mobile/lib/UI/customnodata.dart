import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomNoData extends StatelessWidget {
  const CustomNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(FontAwesomeIcons.faceFrown, size: Get.width / 10),
        const SizedBox(height: 20),
        Text("52".tr, style: Theme.of(context).textTheme.titleSmall)
      ],
    );
  }
}
