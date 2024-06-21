import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bidc_logo_white.png',
                      width: Get.width * 0.55,
                    ),
                    const SizedBox(height: 12),
                    AppWidget().textTitle(
                      title: 'E-DOCUMENT',
                      size: 20,
                      color: AppColor().info,
                    ),
                  ],
                ),
              ),
              AppWidget().loadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
