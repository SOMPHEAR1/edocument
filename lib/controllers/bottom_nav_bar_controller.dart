// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'history_controller.dart';
import 'home_controller.dart';
import 'notification_controller.dart';
import 'notification_count_controller.dart';
import 'profile_controller.dart';
import 'sub_task_document_controller.dart';
import 'task_document_controller.dart';

class BottomNavBarController extends GetxController
    with SingleGetTickerProviderMixin {
  TabController? tabController;

  final HomeController homeController = Get.put(HomeController());
  final HistoryController historyController = Get.put(HistoryController());
  final ProfileController profileController = Get.put(ProfileController());
  final TaskDocumentController taskDocumentController = Get.put(
    TaskDocumentController(issuePlace: ''),
  );
  final SubTaskDocumentController subTaskDocumentController = Get.put(
    SubTaskDocumentController(issuePlace: ''),
  );
  final NotificationController notificationController =
      Get.put(NotificationController());
  final NotificationCountController notificationCountController =
      Get.put(NotificationCountController());

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController!.dispose();
    super.onClose();
  }

  // Function to refresh the current tab's controller
  void refreshCurrentTab() {
    if (tabController != null) {
      final int currentIndex = tabController!.index;
      if (currentIndex == 0) {
        Get.find<TaskDocumentController>().visibleItemCountTask = 5;
        Get.find<SubTaskDocumentController>().visibleItemCountSub = 5;

        Get.find<TaskDocumentController>().taskFilter = '';
        Get.find<SubTaskDocumentController>().subTaskFilter = '';

        homeController.submitData();
        taskDocumentController.submitTaskData();
        subTaskDocumentController.submitSubTaskData();
        notificationController.submitData();
        notificationCountController.submitData();
      } else if (currentIndex == 1) {
        historyController.submitData();
      } else if (currentIndex == 2) {
        return;
      }
    }
  }
}
