import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bottom_nav_bar_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class BottomNavBarScreen extends StatelessWidget {
  const BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavBarController());

    return AppWidget().backgroundImage(
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.tabController,
          children: [
            HomeScreen(),
            HistoryScreen(),
            ProfileScreen(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
        floatingActionButton: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: Platform.isAndroid ? 8 : 2,
              ),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                shadowColor: AppColor().primary,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: AppColor().info,
                    height: 65,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TabBar(
                      onTap: (index) {
                        controller.refreshCurrentTab();
                      },
                      labelColor: AppColor().primary,
                      unselectedLabelColor: AppColor().info,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelStyle: const TextStyle(fontSize: 0),
                      indicatorColor: Colors.transparent,
                      tabs: [
                        tabBarItem(
                          icon: 'assets/icons/home_bold.png',
                          label: 'Home',
                        ),
                        tabBarItem(
                          icon: 'assets/icons/search.png',
                          label: 'Search',
                        ),
                        tabBarItem(
                          icon: 'assets/icons/profile_bold.png',
                          label: 'Profile',
                        ),
                      ],
                      controller: controller.tabController,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  tabBarItem({String? icon, String? label}) {
    return Tab(
      iconMargin: const EdgeInsets.only(bottom: 2),
      icon: Image.asset(
        '$icon',
        height: 26,
        color: AppColor().primary,
      ),
      text: label,
    );
  }
}
