import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/Modules/schedule.dart';
import 'package:testing/Pages/Admin/Doctor/doctor.dart';

class DoctorCard extends StatelessWidget {
  final ScheduleModule item;
  final DoctorController controller;
  const DoctorCard({required this.controller, required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(15)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(
            item.patientInfo!.name!,
            style: Theme.of(context).textTheme.titleSmall,
          )),
          PopupMenuButton(
              iconColor: Theme.of(context).colorScheme.secondary,
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              shadowColor: Theme.of(context).shadowColor,
              itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () => controller.viewProfile(item),
                      child: Center(
                          child: Text("55".tr,
                              style:
                                  Theme.of(context).textTheme.headlineSmall)),
                    ),
                    PopupMenuItem(
                      onTap: () => controller.shareProfile(item),
                      child: Center(
                          child: Text("56".tr,
                              style:
                                  Theme.of(context).textTheme.headlineSmall)),
                    ),
                    PopupMenuItem(
                      onTap: () => controller.requestAnalytics(item),
                      child: Center(
                          child: Text("57".tr,
                              style:
                                  Theme.of(context).textTheme.headlineSmall)),
                    ),
                    PopupMenuItem(
                        onTap: () => controller.requestTreatment(item),
                        child: Center(
                            child: Text("58".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall))),
                  ]),
        ]));
  }
}
