import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:poster/main.dart';
import 'package:poster/pages/poster_third/preview_photo.dart';
import 'package:styled_widget/styled_widget.dart';

import 'poster_third_logic.dart';

class PosterThirdPage extends GetView<PosterThirdLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Work'),
        actions: [
          Obx(() {
            return Visibility(
                visible: controller.isEdit.value,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ).marginOnly(right: 20).gestures(onTap: () {
                  controller.selectedList.clear();
                  controller.isEdit.value = !controller.isEdit.value;
                }));
          }),
          Obx(() {
            return Text(
              controller.isEdit.value ? 'Delete' : 'Edit',
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
            ).marginOnly(right: 20).gestures(onTap: () {
              if (!controller.isEdit.value) {
                controller.isEdit.value = true;
              } else {
                controller.deleteData();
              }
            });
          }),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Obx(() {
          return controller.list.isEmpty
              ? const Center(
                  child: Text('No data'),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 165 / 214),
                  itemCount: controller.list.length,
                  itemBuilder: (_, index) {
                    final entity = controller.list[index];
                    return Container(
                      padding:const EdgeInsets.all(2),
                      child: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            entity.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Obx(() {
                            return Visibility(
                                visible: controller.isEdit.value,
                                child: Icon(
                                  controller.selectedList.contains(entity)
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  size: 20,
                                  color:
                                      controller.selectedList.contains(entity)
                                          ? primaryColor
                                          : Colors.white,
                                ));
                          }),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Obx(() {
                            return Visibility(
                                visible: !controller.isEdit.value,
                                child: Icon(
                                  Icons.save,
                                  size: 20,
                                  color: primaryColor,
                                ).gestures(onTap: () {
                                  controller.saveImage(entity);
                                }));
                          }),
                        )
                      ].toStack(),
                    )
                        .decorated(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: const Color(0xffffdbec), width: 2))
                        .gestures(onTap: () {
                      if (controller.isEdit.value) {
                        controller.selectedList.contains(entity)
                            ? controller.selectedList.remove(entity)
                            : controller.selectedList.add(entity);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PreviewPhoto(entity.image),
                          ),
                        );
                      }
                    });
                  });
        }),
      ).decorated(
          gradient: const LinearGradient(
              colors: [Color(0xffffe5f1), Color(0xfff7f7f7)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.6])),
    );
  }
}
