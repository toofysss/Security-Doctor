import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constant/root.dart';

class Showimage extends StatelessWidget {
  final String image;
  const Showimage({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Code To Display Image
          CachedNetworkImage(
            height: Get.height,
            width: Get.width,
            fit: BoxFit.fill,
            imageUrl: "$api/Operation/GetImg?filename=$image",
            httpHeaders: const {"accept": "*/*"},
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
          ),
          // Back Button
          Positioned(
            top: 15,
            left: 15,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
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
                      shape: BoxShape.circle,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: Get.width / 18,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
