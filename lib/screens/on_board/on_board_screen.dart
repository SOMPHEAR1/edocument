// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/on_board_controller.dart';
import '../../controllers/splash_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';

class OnBoardScreen extends StatefulWidget {
  OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final SplashController splashController = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          body: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.22,
                        ),
                        child: Image.asset('assets/images/bidc_logo_white.png'),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'E-Document',
                        style: TextStyle(
                          color: AppColor().info,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppColor().info,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: onBoarding(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onBoarding() {
    return GetBuilder<OnboardController>(
      init: OnboardController(),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _.pages.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Obx(() {
                        return Container(
                          width: _.currentPageIndex.value == index ? 34 : 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: _.currentPageIndex.value == index
                                ? AppColor().primary
                                : AppColor().primary.withAlpha(120),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  controller: _.pageController,
                  itemCount: _.pages.length,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) => _.onPageChanged(index),
                  itemBuilder: (context, index) {
                    return _.pages[index];
                  },
                ),
              ),
              Obx(() {
                return _.isLastPage
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        margin: const EdgeInsets.only(bottom: 10),
                        width: Get.width * 0.8,
                        child: CupertinoButton(
                          color: AppColor().primary,
                          borderRadius: BorderRadius.circular(30),
                          onPressed: _.nextPage,
                          child: Text(
                            'Get Start',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor().info,
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              onPressed: () {
                                Get.offAllNamed('/login');
                                splashController.isOnBoard = true;
                                getStorage.write(
                                    'onBoard', splashController.isOnBoard);
                              },
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor().primary,
                                ),
                              ),
                            ),
                            CupertinoButton(
                              onPressed: _.nextPage,
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor().primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
