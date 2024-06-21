// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_is_empty, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/task_detail_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../home/view_pdf.dart';

class NotificationDetailScreen extends StatefulWidget {
  NotificationDetailScreen({super.key});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  final TaskDetailController taskDetailController =
      Get.put(TaskDetailController(assignmentID: Get.arguments['assignID']));

  @override
  Widget build(BuildContext context) {
    final item = taskDetailController.taskDetailResModel;

    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: ListView(
            children: [
              appBar(),
              Obx(() {
                return Get.find<TaskDetailController>()
                            .taskDetailResModel
                            .value
                            .taskInfo ==
                        null
                    ? AppWidget().loadingIndicator()
                    : AppWidget().detailInfo(
                        symbol: '${item.value.taskInfo!.documentNumber}',
                        issueDate: '${item.value.taskInfo!.documentDate}',
                        from: '${item.value.taskInfo!.documentReleasePlace}',
                        type: '${item.value.taskInfo!.documentType}',
                        receiveDate: '${item.value.taskInfo!.receivedDate}',
                        title: '${item.value.taskInfo!.documentTitle}',
                      );
              }),
              document(),
              const SizedBox(height: 16),
              assignTo(),
              const SizedBox(height: 16),
              comment(),
              const SizedBox(height: 28),
              AppWidget().buttonWidget(
                text: 'Okay',
                fontColor: AppColor().info,
                color: AppColor().secondary,
                borderColor: AppColor().info,
                action: () => Navigator.pop(context),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  document() {
    final item = taskDetailController.taskDetailResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Document',
              color: AppColor().info,
            ),
          ),
          Obx(
            () {
              return Get.find<TaskDetailController>()
                          .taskDetailResModel
                          .value
                          .taskInfo ==
                      null
                  ? AppWidget().loadingIndicator()
                  : item.value.taskInfo!.listOfFiles == null
                      ? Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: AppWidget().textTitle(
                            title: 'No Document',
                            color: AppColor().info,
                          ),
                        )
                      : ListView.builder(
                          itemCount: item.value.taskInfo!.listOfFiles!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              margin: EdgeInsets.only(top: index == 0 ? 4 : 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidget().textTitle(
                                    title:
                                        '${item.value.taskInfo!.listOfFiles![index].fileName}',
                                    size: 14,
                                    color: AppColor().info,
                                  ),
                                  const SizedBox(height: 4),
                                  AppWidget().shortButtonWidget(
                                    text: 'View',
                                    fontSize: 12,
                                    fontColor: AppColor().info,
                                    color: AppColor().secondary,
                                    borderColor: AppColor().info,
                                    icon: AppWidget().faIconCustom(
                                      icon: FontAwesomeIcons.eye,
                                      size: 14,
                                    ),
                                    action: () {
                                      Get.to(
                                        () => ViewPdfScreen(),
                                        arguments: {
                                          'fileID':
                                              // '${item.value.documentInfo!.listOfFiles![index].fileId}',
                                              '3',
                                          'fileName':
                                              // '${item.value.documentInfo!.listOfFiles![index].fileName}',
                                              'hello.pdf',
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
            },
          ),
        ],
      ),
    );
  }

  assignTo() {
    final item = taskDetailController.taskDetailResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 22, bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor().accent3,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Assign To',
              color: AppColor().info,
            ),
          ),
          Obx(
            () {
              return Get.find<TaskDetailController>()
                          .taskDetailResModel
                          .value
                          .taskInfo ==
                      null
                  ? AppWidget().loadingIndicator()
                  : Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        children: [
                          AppWidget().detailAssignMember(
                            title: 'In Charge BOM :',
                            member: item.value.taskInfo!.vicePresidentId == null
                                ? 'No member'
                                : '${item.value.taskInfo!.vicePresidentName}',
                          ),
                          AppWidget().detailAssignMember(
                            title: 'Coordinate BOM :',
                            member: item.value.taskInfo!.coorDepartmentName ==
                                    null
                                ? 'No member'
                                : '${item.value.taskInfo!.coorDepartmentName}',
                          ),
                          AppWidget().detailAssignMember(
                            title: 'In Charge Dept/Branch:',
                            member: item.value.taskInfo!.deparmentId == null
                                ? 'No member'
                                : '${item.value.taskInfo!.deparmentId}',
                          ),
                          const SizedBox(height: 8),
                          AppWidget().detailAssignMember(
                            title: 'Coordinate Dept/Branch :',
                            member: item.value.taskInfo!.coorDepartmentName ==
                                    null
                                ? 'No member'
                                : '${item.value.taskInfo!.coorDepartmentName}',
                          ),
                          const SizedBox(height: 8),
                          AppWidget().detailAssignMember(
                            title: 'Report Date :',
                            member: item.value.taskInfo!.reportDate == null
                                ? 'No Date Report'
                                : '${item.value.taskInfo!.reportDate}',
                          ),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  comment() {
    final item = taskDetailController.taskDetailResModel;

    return Obx(() {
      return Get.find<TaskDetailController>()
                  .taskDetailResModel
                  .value
                  .taskInfo ==
              null
          ? AppWidget().loadingIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor().accent3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                    child: AppWidget().textLargeTitle(
                      title: 'Comment',
                      color: AppColor().info,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: AppWidget().textTitle(
                      title: item.value.taskInfo!.assignmentText == null
                          ? 'No comment'
                          : '${item.value.taskInfo!.assignmentText}',
                      size: 14,
                      color: AppColor().info,
                    ),
                  ),
                ],
              ),
            );
    });
  }

  appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchRippleEffect(
            onTap: () {
              Get.back();
            },
            backgroundColor: AppColor().accent3,
            rippleColor: Colors.white24,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColor().info,
                  size: 26,
                ),
              ),
            ),
          ),
          AppWidget().textTitle(
            title: 'Notification Detail',
            size: 22,
            color: AppColor().info,
          ),
          const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.transparent,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
