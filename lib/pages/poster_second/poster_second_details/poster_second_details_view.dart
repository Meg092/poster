
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poster/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'poster_second_details_logic.dart';

class PosterSecondDetailsPage extends GetView<PosterSecondDetailsLogic> {
  GlobalKey contentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poster'),
        backgroundColor: Colors.white,
        actions: [
          Text(
            'Save',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ).marginOnly(right: 20).gestures(onTap: () {
            controller.addData(contentKey);
          })
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: GetBuilder<PosterSecondDetailsLogic>(builder: (_) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RepaintBoundary(
                  key: contentKey,
                  child: Container(
                    width: double.infinity,
                    height: 460,
                    child: <Widget>[
                      const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      controller.image != null
                          ? Image.memory(
                              controller.image!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const Center(
                              child: Text(
                                'Select an image',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                      Image.asset(
                        'assets/img${controller.type}.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ).marginSymmetric(horizontal: 16, vertical: 24)
                    ].toStack(),
                  )
                      .decorated(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10))
                      .gestures(onTap: () {
                    controller.imageSelected();
                  }),
                ),
              )
            ].toColumn(),
          );
        }).marginAll(15)),
      ),
    );
  }
}
