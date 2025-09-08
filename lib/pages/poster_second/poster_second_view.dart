import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poster/main.dart';
import 'package:styled_widget/styled_widget.dart';

import 'poster_second_logic.dart';

class PosterSecondPage extends GetView<PosterSecondLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Poster')),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 165 / 214),
            itemCount: 12,
            itemBuilder: (_, index) {
              return <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    child: Image.asset(
                      'assets/img$index.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                    top: 13,
                    right: 13,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 30,
                      alignment: Alignment.center,
                      child: const Text(
                        'Use',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                        .decorated(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15))
                        .gestures(onTap: () {
                      Get.toNamed('/poster_second_details',
                          arguments: index);
                    }))
              ].toStack();
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
