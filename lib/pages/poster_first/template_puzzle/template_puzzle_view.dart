import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster/pages/poster_first/template_puzzle/left_diagonal.dart';
import 'package:poster/pages/poster_first/template_puzzle/right_diagonal.dart';
import 'package:poster/pages/poster_first/template_puzzle/trapezoid_widget.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../db_poster/poster_entity.dart';
import '../../../main.dart';
import 'template_puzzle_logic.dart';

class TemplatePuzzleWidget extends GetView<TemplatePuzzleLogic> {
  File? _image1;
  File? _image2;
  final GlobalKey _renderKey = GlobalKey();

  final List<Map<String, dynamic>> _aspectRatios = [
    {'name': '1:1', 'value': 1.0},
    {'name': '2:3', 'value': 2 / 3},
    {'name': '3:4', 'value': 3 / 4},
    {'name': '16:9', 'value': 16 / 9},
  ];

  double _selectedAspectRatio = 1.0;
  int _template = 0;

  Future<void> _pickImage(int imageNumber) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        imageQuality: 90, maxWidth: 1024, source: ImageSource.gallery);

    if (pickedFile != null) {
      if (imageNumber == 1) {
        _image1 = File(pickedFile.path);
      } else {
        _image2 = File(pickedFile.path);
      }
      controller.update();
    }
  }

  Future<Uint8List> _mergeImages() async {
    try {
      final RenderRepaintBoundary boundary = _renderKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      return byteData!.buffer.asUint8List();
    } catch (e) {
      throw Exception('Failed to merge images: $e');
    }
  }

  Widget _bottomAspectItem(int index) {
    return Expanded(
        child: Container(
      height: 74,
      alignment: Alignment.center,
      child: Text(
        _aspectRatios[index]['name'],
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    )
            .decorated(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: _selectedAspectRatio == _aspectRatios[index]['value']
                    ? Border.all(color: primaryColor, width: 2)
                    : null)
            .marginSymmetric(horizontal: 8)
            .gestures(onTap: () {
      _selectedAspectRatio = _aspectRatios[index]['value'];
      controller.update();
    }));
  }

  Widget _bottomItem() {
    Widget item = const SizedBox();
    if (controller.style == 0) {
      item = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_aspectRatios.length, (v) {
          return _bottomAspectItem(v);
        }).toList(),
      );
    } else {
      item = GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
          itemCount: 6,
          itemBuilder: (_, index) {
            return Container(
              child: <Widget>[
                Image.asset(
                  'assets/template$index.png',
                  fit: BoxFit.cover,
                )
              ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
            )
                .decorated(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: _template == index
                        ? Border.all(color: primaryColor, width: 2)
                        : null)
                .gestures(onTap: () {
              _template = index;
              controller.update();
            });
          });
    }
    return item;
  }

  Widget _centerItem(BoxConstraints max) {
    Widget item = const SizedBox();
    if (_template == 0) {
      item = <Widget>[
        SizedBox(
          width: max.maxWidth,
          height: max.maxHeight,
        ),
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: LeftTrapezoidContainer(
                    width: max.maxWidth,
                    height: max.maxHeight,
                    bottomWidthFactor: 0.1 / _selectedAspectRatio,
                    child: _image1 == null
                        ? const Text(
                            'Add image 1',
                            style: TextStyle(color: Colors.grey),
                          ).marginOnly(top: 100, left: 100)
                        : Image.file(
                            _image1!,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTap: () {
              _pickImage(1);
            })),
        Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: RightTrapezoidContainer(
                    width: max.maxWidth,
                    height: max.maxHeight,
                    topWidthFactor: 0.1 / _selectedAspectRatio,
                    child: _image2 == null
                        ? <Widget>[
                            Positioned(
                                bottom: 100,
                                right: 100,
                                child:const Text(
                                  'Add image 2',
                                  style: TextStyle(color: Colors.grey),
                                ).gestures(onTap: (){
                                  _pickImage(2);
                                }))
                          ].toStack()
                        : Image.file(
                            _image2!,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTapDown: (v) {
              final globalPosition = v.globalPosition;
              final localPosition = v.localPosition;
              final targetRect = Rect.fromLTWH(max.maxWidth / 2,
                  max.maxHeight / 2, max.maxWidth, globalPosition.dy);
              if (targetRect.contains(localPosition)) {
                _pickImage(2);
              } else {
                _pickImage(1);
              }
            }))
      ].toStack();
    } else if (_template == 1) {
      item = <Widget>[
        Container(
                width: max.maxWidth,
                height: max.maxHeight / 2 / _selectedAspectRatio,
                alignment: Alignment.center,
                child: _image1 == null
                    ? const Text(
                        'Add image 1',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Image.file(
                        _image1!,
                        width: max.maxWidth,
                        height: max.maxHeight / 2 / _selectedAspectRatio,
                        fit: BoxFit.cover,
                      ))
            .gestures(onTap: () {
          _pickImage(1);
        }),
        Expanded(
            child: Container(
                    width: max.maxWidth,
                    alignment: Alignment.center,
                    child: _image2 == null
                        ? const Text(
                            'Add image 2',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(
                            _image2!,
                            width: max.maxWidth,
                            height: max.maxHeight,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTap: () {
          _pickImage(2);
        }))
      ].toColumn();
    } else if (_template == 2) {
      item = <Widget>[
        SizedBox(
          width: max.maxWidth,
          height: max.maxHeight,
        ),
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: LeftFirstDiagonalContainer(
                    width: max.maxWidth,
                    height: _selectedAspectRatio > 1
                        ? max.maxHeight / _selectedAspectRatio
                        : max.maxHeight * _selectedAspectRatio,
                    child: _image1 == null
                        ? const Text(
                            'Add image 1',
                            style: TextStyle(color: Colors.grey),
                          ).marginOnly(
                            left: 20,
                            top: (_selectedAspectRatio > 1
                                    ? max.maxHeight / _selectedAspectRatio
                                    : max.maxHeight * _selectedAspectRatio) /
                                2)
                        : Image.file(
                            _image1!,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTap: () {
              _pickImage(1);
            })),
        Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: RightFirstDiagonalContainer(
                    width: max.maxWidth,
                    height: _selectedAspectRatio > 1
                        ? max.maxHeight / _selectedAspectRatio
                        : max.maxHeight * _selectedAspectRatio,
                    child: _image2 == null
                        ? <Widget>[
                            Positioned(
                                top: (_selectedAspectRatio > 1
                                        ? max.maxHeight / _selectedAspectRatio
                                        : max.maxHeight *
                                            _selectedAspectRatio) /
                                    2,
                                right: 20,
                                child: const Text(
                                  'Add image 2',
                                  style: TextStyle(color: Colors.grey),
                                ).gestures(onTap: (){
                                  _pickImage(2);
                                }))
                          ].toStack()
                        : Image.file(
                            _image2!,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTapDown: (v) {
              final globalPosition = v.globalPosition;
              final localPosition = v.localPosition;
              final targetRect = Rect.fromLTWH(max.maxWidth / 2, 0,
                  max.maxWidth / 2, globalPosition.dy * 2 / 3);
              if (targetRect.contains(localPosition)) {
                _pickImage(2);
              } else {
                _pickImage(1);
              }
            }))
      ].toStack();
    } else if (_template == 3) {
      item = <Widget>[
        SizedBox(
          width: max.maxWidth,
          height: max.maxHeight,
        ),
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: LeftSecondDiagonalContainer(
                    width: max.maxWidth,
                    height: _selectedAspectRatio > 1
                        ? max.maxHeight / _selectedAspectRatio
                        : max.maxHeight * _selectedAspectRatio,
                    child: _image1 == null
                        ? const Text(
                            'Add image 1',
                            style: TextStyle(color: Colors.grey),
                          ).marginOnly(
                            left: 20,
                            top: (_selectedAspectRatio > 1
                                    ? max.maxHeight / _selectedAspectRatio
                                    : max.maxHeight * _selectedAspectRatio) /
                                2)
                        : Image.file(
                            _image1!,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTap: () {
              _pickImage(1);
            })),
        Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: RightSecondDiagonalContainer(
                    width: max.maxWidth,
                    height: _selectedAspectRatio > 1
                        ? max.maxHeight / _selectedAspectRatio
                        : max.maxHeight * _selectedAspectRatio,
                    child: _image2 == null
                        ? <Widget>[
                            Positioned(
                                top: (_selectedAspectRatio > 1
                                        ? max.maxHeight / _selectedAspectRatio
                                        : max.maxHeight *
                                            _selectedAspectRatio) /
                                    2,
                                right: 20,
                                child: const Text(
                                  'Add image 2',
                                  style: TextStyle(color: Colors.grey),
                                ).gestures(onTap: (){
                                  _pickImage(2);
                                }))
                          ].toStack()
                        : Image.file(
                            _image2!,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTapDown: (v) {
              final globalPosition = v.globalPosition;
              final localPosition = v.localPosition;
              final targetRect = Rect.fromLTWH(max.maxWidth / 2, max.maxHeight / 7,
                  max.maxWidth , globalPosition.dy);
              if (targetRect.contains(localPosition)) {
                _pickImage(2);
              } else {
                _pickImage(1);
              }
            }))
      ].toStack();
    } else if (_template == 4) {
      item = <Widget>[
        Container(
                width: max.maxWidth,
                height: max.maxHeight / 2 / _selectedAspectRatio,
                alignment: Alignment.center,
                child: _image1 == null
                    ? const Text(
                        'Add image 1',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Image.file(
                        _image1!,
                        width: max.maxWidth,
                        height: max.maxHeight / 2 / _selectedAspectRatio,
                        fit: BoxFit.cover,
                      ))
            .gestures(onTap: () {
          _pickImage(1);
        }),
        const SizedBox(
          height: 15,
        ),
        Expanded(
            child: Container(
                    width: max.maxWidth,
                    alignment: Alignment.center,
                    child: _image2 == null
                        ? const Text(
                            'Add image 2',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(
                            _image2!,
                            width: max.maxWidth,
                            height: max.maxHeight,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTap: () {
          _pickImage(2);
        }))
      ].toColumn();
    } else if (_template == 5) {
      item = <Widget>[
        Container(
                width: max.maxWidth / 2 / _selectedAspectRatio,
                height: max.maxHeight,
                alignment: Alignment.center,
                child: _image1 == null
                    ? const Text(
                        'Add image 1',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Image.file(
                        _image1!,
                        width: max.maxWidth / 2 / _selectedAspectRatio,
                        height: max.maxHeight,
                        fit: BoxFit.cover,
                      ))
            .gestures(onTap: () {
          _pickImage(1);
        }),
        Expanded(
            child: Container(
                    height: max.maxHeight,
                    alignment: Alignment.center,
                    child: _image2 == null
                        ? const Text(
                            'Add image 2',
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(
                            _image2!,
                            width: max.maxWidth,
                            height: max.maxHeight,
                            fit: BoxFit.cover,
                          ))
                .gestures(onTap: () {
          _pickImage(2);
        }))
      ].toRow();
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template jigsaw puzzle'),
        backgroundColor: Colors.white,
        actions: [
          Text(
            'Save',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ).marginOnly(right: 20).gestures(onTap: () async {
            if (_image1 == null || _image2 == null) {
              Fluttertoast.showToast(msg: 'Please select two images');
              return;
            }
            final byte = await _mergeImages();
            await controller.dbPoster.insertPoster(
                PosterEntity(id: 0, createdTime: DateTime.now(), image: byte));
            Fluttertoast.showToast(msg: 'Save success');
            Get.back();
          })
        ],
      ),
      body: GetBuilder<TemplatePuzzleLogic>(builder: (_) {
        return SafeArea(
            child: <Widget>[
          Expanded(
              child: RepaintBoundary(
            key: _renderKey,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                child: LayoutBuilder(builder: (_, max) {
                  return _centerItem(max);
                }),
              ).decorated(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
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
                        color: controller.style == 0
                            ? primaryColor
                            : Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      'Proportion',
                      style: TextStyle(
                          color: controller.style == 0
                              ? Colors.white
                              : Colors.grey),
                    )).gestures(onTap: () {
                  controller.style = 0;
                  controller.update();
                }),
              ),
              Expanded(
                child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: controller.style == 1
                            ? primaryColor
                            : Colors.white),
                    alignment: Alignment.center,
                    child: Text(
                      'Template',
                      style: TextStyle(
                          color: controller.style == 1
                              ? Colors.white
                              : Colors.grey),
                    )).gestures(onTap: () {
                  controller.style = 1;
                  controller.update();
                }),
              )
            ].toRow(),
          ).decorated(
              color: Colors.white, borderRadius: BorderRadius.circular(27)),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 200,
            child: _bottomItem(),
          )
        ].toColumn().marginAll(15));
      }),
    );
  }
}
