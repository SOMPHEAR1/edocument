import 'package:e_document_app/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/color.dart';
import 'splash_controller.dart';

class OnboardController extends GetxController {
  late PageController pageController;
  var currentPageIndex = 0.obs;

  bool get isLastPage => currentPageIndex.value == pages.length - 1;

  final pages = [
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Real-time Notify',
              style: TextStyle(
                color: AppColor().primaryText,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fast notification response.',
              style: TextStyle(
                color: AppColor().primaryText,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/on_board_1.jpg',
            ),
          ),
        ),
        Container(),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Real-time Search',
              style: TextStyle(
                color: AppColor().primaryText,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Realtime search document control.',
              style: TextStyle(
                color: AppColor().primaryText,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/on_board_2.png',
            ),
          ),
        ),
        Container(),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              'Protect & Security',
              style: TextStyle(
                color: AppColor().primaryText,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'All of information protect with security\nconnect with the API.',
              style: TextStyle(
                color: AppColor().primaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/images/onboard_3.png',
            ),
          ),
        ),
        Container(),
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }

  void nextPage() {
    final SplashController splashController = Get.find();
    if (currentPageIndex.value == pages.length - 1) {
      Get.offAllNamed('/login');
      splashController.isOnBoard = true;
      getStorage.write('onBoard', splashController.isOnBoard);
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
