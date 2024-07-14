import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/homeitem.dart';

class HomeCard extends StatelessWidget {
  final HomeModule homeModule;
  final String title;
  const HomeCard({super.key, required this.title, required this.homeModule});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: homeModule.onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [homeModule.startcolor, homeModule.endcolor])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  homeModule.icon,
                  size: Get.width / 12,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.labelLarge,
              )),
            )
          ],
        ),
      ),
    );
  }
}
