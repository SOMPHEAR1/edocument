// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../version.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: Scaffold(
        backgroundColor: AppColor().primary.withOpacity(0.85),
        appBar: AppWidget().customAppBar(),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 24, top: 16),
              alignment: Alignment.centerRight,
              child: AppWidget().shortButtonWidget(
                  text: 'Logout',
                  icon: AppWidget().iconCustom(
                    icon: Icons.logout_rounded,
                    size: 20,
                  ),
                  fontColor: AppColor().info,
                  color: AppColor().accent2,
                  borderColor: AppColor().info,
                  action: () {
                    getStorage.read('publicKey');
                    loginController.logout();
                  }),
            ),
            const SizedBox(height: 8),
            AppWidget().profileLabelForSetting(
              name:
                  '${getStorage.read('lastName')} ${getStorage.read('firstName')}',
              role: '${getStorage.read('roleId')}',
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor().accent3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppWidget().textLargeTitle(
                    title: 'Settings',
                    color: AppColor().info,
                  ),
                  AppWidget().settingButton(
                    title: 'Change Password',
                    icon: Icons.password_rounded,
                    action: () {
                      Get.to(
                        () => ChangePasswordScreen(),
                      );
                    },
                  ),
                  // AppWidget().settingButton(
                  //     title: 'Notification',
                  //     icon: Icons.notifications_rounded,
                  //     widget: AppWidget().textSubTitle(
                  //       title: profileController.isSwitched ? 'ON' : 'OFF',
                  //       size: 13,
                  //       color: AppColor().secondaryText,
                  //     ),
                  //     action: () {
                  //       setState(() {
                  //         profileController.toggleNotifications(
                  //           !profileController.isSwitched,
                  //         );
                  //       });
                  //     }),
                  AppWidget().settingButton(
                    title: 'Language',
                    icon: Icons.language_rounded,
                    widget: AppWidget().textSubTitle(
                      title: 'English',
                      size: 13,
                      color: AppColor().secondaryText,
                    ),
                  ),
                  // AppWidget().settingButton(
                  //   title: 'Help',
                  //   icon:
                  // ),
                  // AppWidget().settingButton(
                  //   title: 'Contact Us',
                  // ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: AppWidget().textNormal(
                title: 'App Version:  v$appVersion',
                color: AppColor().info,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
