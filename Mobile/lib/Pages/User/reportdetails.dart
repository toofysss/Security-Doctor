import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:testing/Modules/schedule.dart';
import 'package:testing/Routing/approuting.dart';
import 'package:testing/constant/root.dart';

import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;

class UserReportDetailsController extends GetxController {
  // Code To Show Image
  showimage(String? image) =>
      Get.toNamed(AppRouting.showimage, parameters: {"image": "$image"});

  Future<void> saveAndLaunchFile(List<int> bytes, String filename) async {
    final directory = await getExternalStorageDirectory();
    final path = directory!.path;
    final file = File("$path/$filename");
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$filename');
  }

  Future<Uint8List> downloadOnlineImage(String imageUrl) async {
    final response =
        await http.get(Uri.parse("$api/Operation/GetImg?filename=$imageUrl"));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image: $imageUrl');
    }
  }

  Future<void> downloadProfile(ScheduleModule item) async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();
    final double pageWidth = page.getClientSize().width;
    final double pageHieght = page.getClientSize().height;
    PdfPage currentPage = document.pages[0];

    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 20);
    final String headerText = "75".tr;
    final Size headerSize = headerFont.measureString(headerText);
    final double headerX = (pageWidth - headerSize.width) / 2;
    const double headerheight = 20;
    double currentY = 0;

    page.graphics.drawString(
      headerText,
      PdfStandardFont(PdfFontFamily.helvetica, 20),
      bounds: Rect.fromLTWH(
          headerX, headerheight, headerSize.width, headerSize.height),
    );
    currentY += headerheight;
    // Construct the patient information
    final String nameText = "${"11".tr} : ${item.patientInfo!.name}";
    final Size nameTextSize = headerFont.measureString(nameText);
    page.graphics.drawString(
      nameText,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(
          0, currentY + 50, nameTextSize.width, nameTextSize.height),
    );
    currentY += 50;

    final String ageText = "${"21".tr} : ${item.patientInfo!.age}";
    final Size ageTextSize = headerFont.measureString(ageText);
    page.graphics.drawString(
      ageText,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(
          0, currentY + 50, ageTextSize.width, ageTextSize.height),
    );
    currentY += 50;

    final String phoneText = "${"16".tr} : ${item.patientInfo!.phone1}";
    final Size phoneTextSize = headerFont.measureString(phoneText);
    page.graphics.drawString(
      phoneText,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(
          0, currentY + 50, phoneTextSize.width, phoneTextSize.height),
    );
    currentY += 50;

    // Construct the Doctor information
    final String doctornameText = "${"73".tr} : ${item.adminInfo!.name}";
    final Size doctornameTextSize = headerFont.measureString(doctornameText);
    page.graphics.drawString(
      doctornameText,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(0, currentY + 50, doctornameTextSize.width,
          doctornameTextSize.height),
    );
    currentY += 50;

    final String doctorphonetext = "${"16".tr} : ${item.adminInfo!.phone}";
    final Size doctorphonetextSize = headerFont.measureString(doctorphonetext);
    page.graphics.drawString(
      doctorphonetext,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(0, currentY + 50, doctorphonetextSize.width,
          doctorphonetextSize.height),
    );
    currentY += 50;

    final String doctordeparttext = "${"48".tr} : ${item.adminInfo!.depart}";
    final Size doctordeparttextSize =
        headerFont.measureString(doctordeparttext);
    page.graphics.drawString(
      doctordeparttext,
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(0, currentY + 50, doctordeparttextSize.width,
          doctordeparttextSize.height),
    );
    currentY += 50;

    for (var operation in item.operation!) {
      final String notestext = operation.usertypeid == 2
          ? "${"76".tr} : ${operation.notes!}"
          : "${"77".tr} : ${operation.notes!}";
      final Size notestextSize = headerFont.measureString(notestext);
      page.graphics.drawString(
        notestext,
        PdfStandardFont(PdfFontFamily.helvetica, 16),
        bounds: Rect.fromLTWH(
            0, currentY + 50, notestextSize.width, notestextSize.height),
      );
      currentY += 50;

      if (operation.answers!.isNotEmpty) {
        final String answerstext = "${"78".tr} : ${operation.answers!}";
        final Size answerstextSize = headerFont.measureString(answerstext);
        page.graphics.drawString(
          answerstext,
          PdfStandardFont(PdfFontFamily.helvetica, 16),
          bounds: Rect.fromLTWH(
              0, currentY + 50, answerstextSize.width, answerstextSize.height),
        );
      }

      for (var images in operation.operationImage!) {
        currentPage = document.pages.add();
        final Uint8List imageData = await downloadOnlineImage(images.image!);
        final PdfBitmap image = PdfBitmap(imageData);
        currentPage.graphics.drawImage(
          image,
          Rect.fromLTWH(0, 0, pageWidth, pageHieght),
        );
      }
    }

    final List<int> bytes = await document.save();
    document.dispose();
    saveAndLaunchFile(bytes, "${item.patientInfo!.name}.pdf");
  }
}

class UserReportDetails extends StatelessWidget {
  final ScheduleModule item;
  const UserReportDetails({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: UserReportDetailsController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              // Back Button
              leading: IconButton(
                  highlightColor:
                      Theme.of(context).colorScheme.primary.withOpacity(.1),
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: Get.width / 18,
                    color: Theme.of(context).iconTheme.color,
                  )),
              // Name Of Doctor
              title: Text("${item.adminInfo!.name}",
                  style: Theme.of(context).textTheme.titleSmall),

              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: () => controller.downloadProfile(item),
                      icon: Icon(
                        Icons.download_rounded,
                        size: Get.width / 18,
                        color: Theme.of(context).iconTheme.color,
                      )),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  Paitent Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${"67".tr}\n${item.patientInfo!.name}",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${"16".tr}\n${item.patientInfo!.phone1}",
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Divider(
                      endIndent: 50,
                      indent: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  //  Doctor Info
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${"73".tr}\n${item.adminInfo!.name}",
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${"74".tr}\n${item.closedate}",
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: ListView.builder(
                        itemCount: item.operation!.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        itemBuilder: (_, index) {
                          var data = item.operation![index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Info about who the patient sent them to
                              ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(150),
                                  child: CachedNetworkImage(
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                    imageUrl:
                                        "$api/AdminInfo/GetImg?filename=${data.operationAdminInfo!.image!}",
                                    httpHeaders: const {"accept": "*/*"},
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(logo),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${data.operationAdminInfo!.name}",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ),
                              // Result about who the patient sent them to
                              Visibility(
                                visible: data.answers!.isNotEmpty,
                                child: Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 15),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary)),
                                  child: Text(
                                    data.answers!,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ),
                              // Result Image about who the patient sent them to
                              Visibility(
                                visible: data.operationImage!.isNotEmpty,
                                child: SizedBox(
                                  height: 400,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      itemCount: data.operationImage!.length,
                                      itemBuilder: (_, index) {
                                        return GestureDetector(
                                          onTap: () => controller.showimage(data
                                              .operationImage![index].image),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                width: 250,
                                                httpHeaders: const {
                                                  "accept": "*/*"
                                                },
                                                imageUrl:
                                                    "$api/Operation/GetImg?filename=${data.operationImage![index].image}",
                                                progressIndicatorBuilder:
                                                    (context, url,
                                                            downloadProgress) =>
                                                        Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 120,
                                                  width: 120,
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
                                        );
                                      }),
                                ),
                              )
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}
