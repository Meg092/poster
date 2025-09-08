import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:poster/db_poster/poster_entity.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../main.dart';
import 'long_image_splicing_details_logic.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class LongImageSplicingDetailsPage
    extends GetView<LongImageSplicingDetailsLogic> {

  final GlobalKey _scrollKey = GlobalKey();
  final GlobalKey _vContentKey = GlobalKey();
  final GlobalKey _hContentKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  Future<Uint8List?> _captureEntireContent() async {
    controller.isCapture = true;

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final RenderRepaintBoundary boundary = _scrollKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final RenderBox? contentBox = (controller.stitchType == StitchType.vertical ? _vContentKey : _hContentKey).currentContext?.findRenderObject() as RenderBox?;
      if (contentBox == null) {
        print('Content box not found');
        return null;
      }

      if (controller.stitchType == StitchType.vertical) {
        return await _captureVerticalContent(boundary, contentBox);
      } else {
        return await _captureHorizontalContent(boundary, contentBox);
      }

    } catch (e) {
      print('Capture error: $e');
      return null;
    } finally {
      controller.isCapture = false;
    }
  }

  Future<Uint8List?> _captureVerticalContent(RenderRepaintBoundary boundary, RenderBox contentBox) async {
    final double totalContentHeight = contentBox.size.height;
    final double viewportHeight = boundary.size.height;

    if (totalContentHeight <= viewportHeight) {
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }

    List<Uint8List> screenshots = [];
    double currentScrollPosition = 0;

    while (currentScrollPosition < totalContentHeight) {
      _scrollController.jumpTo(currentScrollPosition);
      await Future.delayed(const Duration(milliseconds: 100));

      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        screenshots.add(byteData.buffer.asUint8List());
      }

      currentScrollPosition += viewportHeight;
      if (currentScrollPosition > totalContentHeight) {
        currentScrollPosition = totalContentHeight;
      }
    }

    _scrollController.jumpTo(0);
    return await _mergeVerticalScreenshots(screenshots, totalContentHeight);
  }

  Future<Uint8List?> _captureHorizontalContent(RenderRepaintBoundary boundary, RenderBox contentBox) async {
    final double totalContentWidth = contentBox.size.width;
    final double viewportWidth = boundary.size.width;

    if (totalContentWidth <= viewportWidth) {
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    }

    List<Uint8List> screenshots = [];
    double currentScrollPosition = 0;

    while (currentScrollPosition < totalContentWidth) {
      _scrollController.jumpTo(currentScrollPosition);
      await Future.delayed(const Duration(milliseconds: 150));

      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        screenshots.add(byteData.buffer.asUint8List());
      }

      currentScrollPosition += viewportWidth;
      if (currentScrollPosition > totalContentWidth) {
        currentScrollPosition = totalContentWidth;
      }
    }

    _scrollController.jumpTo(0);
    return await _mergeHorizontalScreenshots(screenshots, totalContentWidth);
  }


  Future<Uint8List?> _mergeVerticalScreenshots(List<Uint8List> screenshots, double totalHeight) async {
    if (screenshots.isEmpty) return null;

    final codec = await ui.instantiateImageCodec(screenshots.first);
    final frame = await codec.getNextFrame();
    final ui.Image firstImage = frame.image;
    final int imageWidth = firstImage.width;
    firstImage.dispose();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTRB(0, 0, imageWidth.toDouble(), totalHeight));

    double currentY = 0;
    for (final bytes in screenshots) {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final double drawHeight = (currentY + image.height > totalHeight)
          ? totalHeight - currentY
          : image.height.toDouble();

      canvas.drawImageRect(
        image,
        ui.Rect.fromLTRB(0, 0, image.width.toDouble(), drawHeight),
        ui.Rect.fromLTRB(0, currentY, image.width.toDouble(), currentY + drawHeight),
        ui.Paint(),
      );

      image.dispose();
      currentY += drawHeight;
    }

    final picture = recorder.endRecording();
    final mergedImage = await picture.toImage(imageWidth, totalHeight.toInt());
    final byteData = await mergedImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  Future<Uint8List?> _mergeHorizontalScreenshots(List<Uint8List> screenshots, double totalWidth) async {
    if (screenshots.isEmpty) return null;

    final codec = await ui.instantiateImageCodec(screenshots.first);
    final frame = await codec.getNextFrame();
    final ui.Image firstImage = frame.image;
    final int imageHeight = firstImage.height;
    firstImage.dispose();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder, ui.Rect.fromLTRB(0, 0, totalWidth, imageHeight.toDouble()));

    double currentX = 0;
    for (final bytes in screenshots) {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final ui.Image image = frame.image;

      final double drawWidth = (currentX + image.width > totalWidth)
          ? totalWidth - currentX
          : image.width.toDouble();

      canvas.drawImageRect(
        image,
        ui.Rect.fromLTRB(0, 0, drawWidth, image.height.toDouble()),
        ui.Rect.fromLTRB(currentX, 0, currentX + drawWidth, image.height.toDouble()),
        ui.Paint(),
      );

      image.dispose();
      currentX += drawWidth;
    }

    final picture = recorder.endRecording();
    final mergedImage = await picture.toImage(totalWidth.toInt(), imageHeight);
    final byteData = await mergedImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  Future<void> _saveImage(BuildContext context) async {
    if (controller.selectedImages.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select an image');
      return;
    }
    final byte = await _captureEntireContent();
    if (byte == null) {
      Fluttertoast.showToast(msg: 'Capture error');
      return;
    }
    await controller.dbPoster.insertPoster(
        PosterEntity(id: 0, createdTime: DateTime.now(), image: byte));
    Fluttertoast.showToast(msg: 'Save success');
    Get.back();
  }

  Widget _item() {
    Widget item = const SizedBox();
    if (controller.selectedImages.isEmpty) {
      item = const Center(
        child: Text('Add images'),
      );
    } else {
      List<Image> imageWidgets = [];
      for (var file in controller.selectedImages) {
        imageWidgets.add(Image.file(File(file.path),
            width: controller.stitchType == StitchType.vertical
                ? double.infinity
                : null,
            height: controller.stitchType == StitchType.horizontal ? double.infinity : null,
            fit: BoxFit.cover));
      }
      item = RepaintBoundary(
        key: _scrollKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: controller.stitchType == StitchType.vertical
              ? Axis.vertical
              : Axis.horizontal,
          controller: _scrollController,
          child: controller.stitchType == StitchType.vertical
              ? Column(
                  key: _vContentKey,
                  children: imageWidgets,
                )
              : Row(
                  key: _hContentKey,
                  children: imageWidgets,
                ),
        ),
      );
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Long image splicing'),
        backgroundColor: Colors.white,
        actions: [
          Text(
            'Save',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ).marginOnly(right: 20).gestures(onTap: () {
            _saveImage(context);
          })
        ],
      ),
      body: GetBuilder<LongImageSplicingDetailsLogic>(builder: (_) {
        return SafeArea(
            child: <Widget>[
          Expanded(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(width: double.infinity, child: _item())
                .decorated(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xffeaeaea), width: 1))
                .gestures(onTap: () {
              controller.pickImages();
            }),
          )),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            height: 54,
            padding: const EdgeInsets.all(7),
            child: <Widget>[
              Expanded(
                child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: StitchType.vertical == controller.stitchType
                            ? primaryColor
                            : Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      'Vertical',
                      style: TextStyle(
                          color: controller.stitchType == StitchType.vertical
                              ? Colors.white
                              : Colors.grey),
                    )).gestures(onTap: () {
                  controller.stitchType = StitchType.vertical;
                  controller.update();
                }),
              ),
              Expanded(
                child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: StitchType.horizontal == controller.stitchType
                            ? primaryColor
                            : Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      'Horizontal',
                      style: TextStyle(
                          color: controller.stitchType == StitchType.horizontal
                              ? Colors.white
                              : Colors.grey),
                    )).gestures(onTap: () {
                  controller.stitchType = StitchType.horizontal;
                  controller.update();
                }),
              )
            ].toRow(),
          ).decorated(
              color: Colors.white, borderRadius: BorderRadius.circular(27))
        ].toColumn().marginAll(15));
      }),
    );
  }
}
