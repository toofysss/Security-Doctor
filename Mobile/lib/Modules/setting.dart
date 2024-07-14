import 'package:flutter/material.dart';

class SettingModel {
  final IconData iconData;
  final bool visible;
  final Function() onTap;
  SettingModel({
    required this.iconData,
    this.visible = true,
    required this.onTap,
  });
}
