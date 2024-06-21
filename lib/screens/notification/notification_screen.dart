// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_is_empty

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/notification_controller.dart';
import '../../controllers/notification_count_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../assigned/assigned_screen.dart';
import '../home/comment_screen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    final item = notificationController.notifyResModel;

    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: Obx(() {
            return Get.find<NotificationController>()
                        .notifyResModel
                        .value
                        .errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : AppWidget().pullRefresh(
                    action: () {
                      setState(() {
                        notificationController.visibleItemCount = 6;
                        notificationController.submitData();
                      });
                    },
                    child: ListView(
                      children: [
                        appBar(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            item.value.notification == null
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: AppWidget().textTitle(
                                      title: 'No Notification',
                                      color: AppColor().info,
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: min(
                                        notificationController.visibleItemCount,
                                        item.value.notification!.length),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final convertPostTime = DateTime.parse(
                                          '${item.value.notification![index].postDate}');

                                      return Column(
                                        children: [
                                          notificationItem(
                                            notifyTitle:
                                                '${item.value.notification![index].notificationMessage}',
                                            profile: item
                                                        .value
                                                        .notification![index]
                                                        .documentId !=
                                                    null
                                                ? Container(
                                                    width: 42,
                                                    height: 42,
                                                    decoration: BoxDecoration(
                                                      color: AppColor().info,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: item
                                                                      .value
                                                                      .notification![
                                                                          index]
                                                                      .state ==
                                                                  '0'
                                                              ? Colors.red
                                                              : Colors
                                                                  .transparent),
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: Image.asset(
                                                          'assets/icons/app_logo.png',
                                                        ).image,
                                                      ),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: item
                                                                .value
                                                                .notification![
                                                                    index]
                                                                .state ==
                                                            '0'
                                                        ? Colors.red
                                                        : Colors.transparent,
                                                    child: ProfilePicture(
                                                      name:
                                                          '${item.value.notification![index].assigner}',
                                                      radius: 19,
                                                      fontsize: 14,
                                                    ),
                                                  ),
                                            isRead:
                                                '${item.value.notification![index].state}',
                                            postDate: GetTimeAgo.parse(
                                                convertPostTime),
                                            action: () {
                                              if (item
                                                      .value
                                                      .notification![index]
                                                      .assignmentId !=
                                                  null) {
                                                Get.to(
                                                  () => AssignedScreen(),
                                                  arguments: {
                                                    'documentType': 'Task',
                                                    'assignmentId':
                                                        '${item.value.notification![index].assignmentId}',
                                                    'assignerName':
                                                        '${item.value.notification![index].assigner}',
                                                  },
                                                );
                                              } else if (item
                                                      .value
                                                      .notification![index]
                                                      .documentId !=
                                                  null) {
                                                Get.to(
                                                  () => CommentScreen(),
                                                  arguments: {
                                                    'docID':
                                                        '${item.value.notification![index].documentId}',
                                                    'documentType': 'new',
                                                  },
                                                );
                                              } else {
                                                return;
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                            item.value.notification == null
                                ? Container()
                                : notificationController.visibleItemCount <
                                        item.value.notification!.length
                                    ? GestureDetector(
                                        onTap: () {
                                          EasyLoading.show(
                                              status: 'Loading...');

                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            setState(() {
                                              notificationController
                                                  .loadMoreItems(item.value
                                                      .notification!.length);
                                            });
                                            EasyLoading.dismiss();
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            AppWidget().textNormal(
                                              title: 'See more',
                                              color: AppColor().info,
                                              size: 15,
                                            ),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              size: 32,
                                              color: AppColor().info,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

  appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchRippleEffect(
            onTap: () {
              Get.find<NotificationCountController>().submitData();
              Future.delayed(const Duration(milliseconds: 100), () {
                Get.back();
              });
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
            title: 'Notification',
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

  notificationItem({
    String? notifyTitle,
    Widget? profile,
    String? isRead,
    Function()? action,
    String? postDate,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 12),
      child: TouchRippleEffect(
        onTap: () {
          action!.call();
        },
        backgroundColor: AppColor().info,
        rippleColor: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isRead == '0' ? Colors.blue.shade200 : AppColor().info,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(2, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: profile!,
                          ),
                          Flexible(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 4, right: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: '$notifyTitle',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: AppColor().primaryText,
                                        fontWeight: isRead == '0'
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7),
                                    child: isRead == '0'
                                        ? AppWidget().textTitle(
                                            title: '$postDate',
                                            size: 12,
                                            color: AppColor().primaryText,
                                          )
                                        : AppWidget().textNormal(
                                            title: '$postDate',
                                            size: 12,
                                            color: AppColor().secondaryText,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              isRead == '0'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        width: 6,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColor().error,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
