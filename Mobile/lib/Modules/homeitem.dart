import 'package:flutter/material.dart';

class HomeModule {
  Color endcolor;
  Color startcolor;
  IconData icon;
  Function() onTap;

  HomeModule({
    required this.icon,
    required this.startcolor,
    required this.endcolor,
    required this.onTap,
  });
}
