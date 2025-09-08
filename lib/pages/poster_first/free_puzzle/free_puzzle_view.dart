import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../db_poster/poster_entity.dart';
import '../../../main.dart';
import 'free_puzzle_logic.dart';

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart';

class FreePuzzleWidget extends GetView<FreePuzzleLogic> {
  File? _image1;
  File? _image2;
  final GlobalKey _renderKey = GlobalKey();

  Offset _position1 = const Offset(42, 88);
  Offset _position2 = const Offset(149, 214);
  double _scale1 = 1.0;
  double _scale2 = 1.0;

  final List<Map<String, dynamic>> _aspectRatios = [
    {'name': '1:1', 'value': 1.0},
    {'name': '2:3', 'value': 2 / 3},
    {'name': '3:4', 'value': 3 / 4},
    {'name': '16:9', 'value': 16 / 9},
  ];
  double _selectedAspectRatio = 1.0;

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

  Widget _buildDraggableImage(File? image, int index) {
    final currentPosition = index == 1 ? _position1 : _position2;
    final currentScale = index == 1 ? _scale1 : _scale2;

    return Positioned(
      left: currentPosition.dx,
      top: currentPosition.dy,
      child: GestureDetector(
        onTap: () {
          _pickImage(index);
        },
        onScaleUpdate: (details) {
          if (index == 1) {
            _position1 += details.focalPointDelta;
            _scale1 = (currentScale * details.scale).clamp(0.5, 3.0);
          } else {
            _position2 += details.focalPointDelta;
            _scale2 = (currentScale * details.scale).clamp(0.5, 3.0);
          }
          controller.update();
        },
        child: Transform.scale(
          scale: currentScale,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 152,
              height: 152 / _selectedAspectRatio,
              child: image == null
                  ? <Widget>[
                      const Text(
                        'Add image',
                        style: TextStyle(color: Colors.grey),
                      )
                    ].toColumn(mainAxisAlignment: MainAxisAlignment.center)
                  : Image.file(image, fit: BoxFit.cover),
            ).decorated(
                color: Colors.white,
                border: Border.all(color: primaryColor, width: 2),
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
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

  Widget _bottomItem(int index) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Puzzle'),
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
      body: GetBuilder<FreePuzzleLogic>(builder: (_) {
        return SafeArea(
            child: <Widget>[
          Expanded(
              child: RepaintBoundary(
            key: _renderKey,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: <Widget>[
                _buildDraggableImage(_image1, 1),
                _buildDraggableImage(_image2, 2),
              ].toStack(),
            ).decorated(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
          )),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: List.generate(_aspectRatios.length, (v) {
              return _bottomItem(v);
            }).toList(),
          )
        ].toColumn().marginAll(15));
      }),
    );
  }
}
