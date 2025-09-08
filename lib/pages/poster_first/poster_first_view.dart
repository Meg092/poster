import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'poster_first_logic.dart';

class PosterFirstPage extends GetView<PosterFirstLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
              child: <Widget>[
            const Positioned(
                left: 15,
                top: 60,
                child: Text(
                  'Jigsaw puzzle poster',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                )),
            const Positioned(
                left: 15,
                top: 110,
                child: Text('Make jigsaw puzzles simply and for free')),
            <Widget>[
              Expanded(
                  child: Container(
                height: 155,
                child: <Widget>[
                  Image.asset(
                    'assets/icon0.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Template jigsaw puzzle')
                ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
              )
                      .decorated(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10))
                      .gestures(onTap: () {
                        Get.toNamed('/template_puzzle');
                  })),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                height: 155,
                child: <Widget>[
                  Image.asset(
                    'assets/icon1.png',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Free Puzzle')
                ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
              )
                      .decorated(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10))
                      .gestures(onTap: () {
                        Get.toNamed('/free_puzzle');
                  }))
            ].toRow().marginOnly(left: 15, right: 15, top: 230),
            Container(
              width: double.infinity,
              height: 155,
              child: <Widget>[
                Image.asset(
                  'assets/icon2.png',
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Long image splicing')
              ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
            )
                .decorated(
                    color: Colors.white, borderRadius: BorderRadius.circular(10))
                .marginOnly(left: 15, right: 15, top: 400)
                .gestures(onTap: () {
                  Get.toNamed('/long_image_splicing_details');
            })
          ].toStack()),
        ),
      ).decorated(
          image: const DecorationImage(
              image: AssetImage('assets/bg.png'), fit: BoxFit.fill)),
    );
  }
}
