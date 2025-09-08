import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poster/pages/poster_first/poster_first_view.dart';
import 'package:poster/pages/poster_second/poster_second_view.dart';
import 'package:poster/pages/poster_third/poster_third_logic.dart';
import 'package:poster/pages/poster_third/poster_third_view.dart';

import 'poster_tab_logic.dart';

class PosterTabPage extends GetView<PosterTabLogic> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          PosterFirstPage(),
          PosterSecondPage(),
          PosterThirdPage()
        ],
      ),
      bottomNavigationBar: Obx(() => _navPosterBars()),
    );
  }

  Widget _navPosterBars() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item0Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item0Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Puzzle',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item1Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item1Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Poster',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item2Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item2Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Work',
        ),
      ],
      currentIndex: controller.currentIndex.value,
      onTap: (index) {
        controller.currentIndex.value = index;
        controller.pageController.jumpToPage(index);
        if (index == 2) {
          PosterThirdLogic thirdLogic = Get.find();
          thirdLogic.getData();
        }
      },
    );
  }
}
