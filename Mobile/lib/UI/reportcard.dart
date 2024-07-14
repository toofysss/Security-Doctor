import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/schedule.dart';
import 'package:testing/constant/root.dart';

class ReportCard extends StatelessWidget {
  final ScheduleModule item;
  const ReportCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    "$api/AdminInfo/GetImg?filename=${item.adminInfo!.image!}"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "${item.adminInfo!.name}",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "${item.adminInfo!.depart}",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            )
          ],
        ));
  }
}
