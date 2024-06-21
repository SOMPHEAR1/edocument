// ignore_for_file: must_be_immutable, unnecessary_null_comparison, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:math';

import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/assign_doc_controller.dart';
import '../../controllers/assign_doc_in_search_controller.dart';
import '../../controllers/assign_staff_controller.dart';
import '../../controllers/assign_staff_in_search_controller.dart';
import '../../controllers/bom_controller.dart';
import '../../controllers/comment_controller.dart';
import '../../controllers/director_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/notification_count_controller.dart';
import '../../controllers/staff_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../../widget/single_date_picker.dart';
import '../assigned/assigned_screen.dart';
import 'view_pdf.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final CommentController commentController = Get.put(CommentController(
    documentID: Get.arguments['docID'],
  ));
  final BOMController bomController = Get.put(BOMController());
  final DirectorController directorController = Get.put(DirectorController());
  final StaffController staffController = Get.put(StaffController());

  final AssignDocController assignDocController =
      Get.put(AssignDocController());
  final AssignDocInSearchController assignDocInSearchController =
      Get.put(AssignDocInSearchController());
  final AssignStaffController assignStaffController =
      Get.put(AssignStaffController());
  final AssignStaffInSearchController assignStaffInSearchController =
      Get.put(AssignStaffInSearchController());

  @override
  Widget build(BuildContext context) {
    final item = commentController.documentDetailResModel;

    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TouchRippleEffect(
                      onTap: () {
                        Get.find<NotificationController>().submitData();
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
                      title: 'Assign Document',
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
              ),
              Obx(() {
                return Get.find<CommentController>()
                            .documentDetailResModel
                            .value
                            .errorCode ==
                        null
                    ? AppWidget().loadingIndicator()
                    : AppWidget().detailInfo(
                        symbol: '${item.value.documentInfo!.documentNumber}',
                        issueDate: '${item.value.documentInfo!.documentDate}',
                        from:
                            '${item.value.documentInfo!.documentReleasePlace}',
                        type: '${item.value.documentInfo!.documentType}',
                        receiveDate:
                            '${item.value.documentInfo!.submissionDateTime}',
                        title: '${item.value.documentInfo!.documentTitle}',
                      );
              }),
              document(),
              Get.arguments['documentType'] == 'new'
                  ? Container()
                  : taskProposal(),
              getStorage.read('roleId') == 'Staff'
                  ? Container()
                  : assignTo(context),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  document() {
    final item = commentController.documentDetailResModel;

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
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AppWidget().textLargeTitle(
              title: 'Attachment',
              color: AppColor().info,
            ),
          ),
          Obx(
            () {
              return Get.find<CommentController>()
                          .documentDetailResModel
                          .value
                          .errorCode ==
                      null
                  ? AppWidget().loadingIndicator()
                  : item.value.documentInfo!.listOfFiles == null
                      ? Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 12),
                          child: AppWidget().textTitle(
                            title: 'No Document',
                            color: AppColor().info,
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              item.value.documentInfo!.listOfFiles!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8),
                              margin: EdgeInsets.only(top: index == 0 ? 4 : 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppWidget().textTitle(
                                    title:
                                        '${item.value.documentInfo!.listOfFiles![index].fileName}',
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
                                              '${item.value.documentInfo!.listOfFiles![index].fileId}',
                                          'fileName':
                                              '${item.value.documentInfo!.listOfFiles![index].fileName}',
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

  taskProposal() {
    final item = commentController.taskProposalResModel;
    final docItem = commentController.documentDetailResModel;

    return Obx(() {
      return item.value.task == null && item.value.subTask == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: AppWidget().textLargeTitle(
                      title: 'Assignment',
                      color: AppColor().info,
                    ),
                  ),

                  // task
                  Get.find<CommentController>()
                              .taskProposalResModel
                              .value
                              .errorCode ==
                          null
                      ? AppWidget().loadingIndicator()
                      : item.value.task == null && item.value.subTask == null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 12),
                              child: AppWidget().textTitle(
                                title: 'No Document',
                                color: AppColor().info,
                              ),
                            )
                          : item.value.task == null
                              ? Container()
                              : ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                        height:
                                            item.value.task == null ? 0 : 8),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: AppWidget().textTitle(
                                        title: 'Task',
                                        color: AppColor().info,
                                      ),
                                    ),
                                    ListView.builder(
                                      itemCount: min(
                                          commentController
                                              .visibleTaskItemCount,
                                          item.value.task!.length),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: AppWidget().taskProposalItem(
                                            docBy: 'Assigned by',
                                            byPerson:
                                                '${item.value.task![index].assignerName}',
                                            assignedDate:
                                                'Assigned Date: ${item.value.task![index].assignedDate}',
                                            reportDate: item.value.task![index]
                                                        .reportDate ==
                                                    null
                                                ? 'Report Date: No report date'
                                                : 'Report Date: ${item.value.task![index].reportDate}',
                                            progress: item.value.task![index]
                                                        .progress ==
                                                    null
                                                ? '0'
                                                : '${item.value.task![index].progress}',
                                            action: () {
                                              Get.to(() => AssignedScreen(),
                                                  arguments: {
                                                    'documentType':
                                                        getStorage.read(
                                                                    'roleId') ==
                                                                'CEO'
                                                            ? 'SubTask'
                                                            : 'Task',
                                                    'from': 'search',
                                                    'docId':
                                                        '${item.value.task![index].documentId}',
                                                    'assignmentId':
                                                        '${item.value.task![index].assignmentId}',
                                                    'assignerName':
                                                        '${item.value.task![index].assignerName}',
                                                    'docNumber':
                                                        '${docItem.value.documentInfo!.documentNumber}',
                                                    'docTitle':
                                                        '${docItem.value.documentInfo!.documentTitle}',
                                                    'assignDate':
                                                        '${item.value.task![index].assignedDate}',
                                                    'feedback': item
                                                                .value
                                                                .task![index]
                                                                .numberOfFeedbacks ==
                                                            null
                                                        ? '0'
                                                        : '${item.value.task![index].numberOfFeedbacks}',
                                                    'progress': item
                                                                .value
                                                                .task![index]
                                                                .progress ==
                                                            null
                                                        ? '0'
                                                        : '${item.value.task![index].progress}',
                                                  });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                  SizedBox(height: item.value.task == null ? 0 : 12),
                  item.value.task == null
                      ? Container()
                      : commentController.visibleTaskItemCount <
                              item.value.task!.length
                          ? GestureDetector(
                              onTap: () {
                                EasyLoading.show(status: 'Loading...');

                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    commentController.loadMoreTaskItems(
                                        item.value.task!.length);
                                  });
                                  EasyLoading.dismiss();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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

                  // sub task
                  Get.find<CommentController>()
                              .taskProposalResModel
                              .value
                              .errorCode ==
                          null
                      ? AppWidget().loadingIndicator()
                      : item.value.subTask == null
                          ? Container()
                          : ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                    height: item.value.subTask == null ? 0 : 8),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: AppWidget().textTitle(
                                    title: 'Assigned Task',
                                    color: AppColor().info,
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: min(
                                      commentController.visibleSubItemCount,
                                      item.value.subTask!.length),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: AppWidget().taskProposalItem(
                                        docBy: 'Report by',
                                        byPerson: getStorage.read('roleId') ==
                                                'Director'
                                            ? 'Staff: ${item.value.subTask![index].assigneeName}'
                                            : item.value.subTask![index]
                                                            .vicePresidentName ==
                                                        null &&
                                                    item.value.subTask![index]
                                                            .coorVicePresidentName ==
                                                        null &&
                                                    item.value.subTask![index]
                                                            .departmentName ==
                                                        null &&
                                                    item.value.subTask![index]
                                                            .coorDepartmentName ==
                                                        null
                                                ? ''
                                                : '${item.value.subTask![index].vicePresidentName == null && item.value.subTask![index].coorVicePresidentName == null ? '' : '   BOM: ${item.value.subTask![index].vicePresidentName == null ? '' : '${item.value.subTask![index].vicePresidentName};'} ${item.value.subTask![index].coorVicePresidentName ?? ''}\n'}   Dept/Branch: ${item.value.subTask![index].departmentName ?? ''}; ${item.value.subTask![index].coorDepartmentName ?? ''}',
                                        assignedDate:
                                            'Assigned Date: ${item.value.subTask![index].assignedDate}',
                                        reportDate: item.value.subTask![index]
                                                    .reportDate ==
                                                null
                                            ? 'Report Date: No report date'
                                            : 'Report Date: ${item.value.subTask![index].reportDate}',
                                        progress: item.value.subTask![index]
                                                    .progress ==
                                                null
                                            ? '0'
                                            : '${item.value.subTask![index].progress}',
                                        action: () {
                                          Get.to(() => AssignedScreen(),
                                              arguments: {
                                                'documentType': 'SubTask',
                                                'from': 'search',
                                                'docId':
                                                    '${item.value.subTask![index].documentId}',
                                                'assignmentId':
                                                    '${item.value.subTask![index].assignmentId}',
                                                'assignerName':
                                                    '${item.value.subTask![index].assignerName}',
                                                'docNumber':
                                                    '${docItem.value.documentInfo!.documentNumber}',
                                                'docTitle':
                                                    '${docItem.value.documentInfo!.documentTitle}',
                                                'assignDate':
                                                    '${item.value.subTask![index].assignedDate}',
                                                'feedback': item
                                                            .value
                                                            .subTask![index]
                                                            .numberOfFeedbacks ==
                                                        null
                                                    ? '0'
                                                    : '${item.value.subTask![index].numberOfFeedbacks}',
                                                'progress': item
                                                            .value
                                                            .subTask![index]
                                                            .progress ==
                                                        null
                                                    ? '0'
                                                    : '${item.value.subTask![index].progress}',
                                              });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                  SizedBox(height: item.value.subTask == null ? 0 : 12),
                  item.value.subTask == null
                      ? Container()
                      : commentController.visibleSubItemCount <
                              item.value.subTask!.length
                          ? GestureDetector(
                              onTap: () {
                                EasyLoading.show(status: 'Loading...');

                                Future.delayed(const Duration(seconds: 1), () {
                                  setState(() {
                                    commentController.loadMoreSubItems(
                                        item.value.subTask!.length);
                                  });
                                  EasyLoading.dismiss();
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
            );
    });
  }

  assignTo(BuildContext context) {
    final item = commentController.taskProposalResModel;

    return Obx(() {
      return item.value.task == null && item.value.subTask == null ||
              item.value.subTask == null ||
              Get.arguments['documentType'] == 'assigned' ||
              Get.arguments['documentType'] == 'new'
          ? Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 28),
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
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 12),
                        child: AppWidget().textLargeTitle(
                          title: 'Assign To',
                          color: AppColor().info,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            checkAssignedRole(),
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              child: AppWidget().textTitle(
                                title: 'Report',
                                size: 15,
                                color: AppColor().info,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColor().accent2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    width: 110,
                                    child: AppWidget().textTitle(
                                      title: 'Report Date :',
                                      size: 12,
                                      color: AppColor().info,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Row(
                                            children: [
                                              AppWidget().textNormal(
                                                title: commentController
                                                            .dateValue[0] ==
                                                        null
                                                    ? 'Select date'
                                                    : commentController
                                                        .formatDateTime(
                                                        commentController
                                                            .dateValue[0]!,
                                                      ),
                                                size: 14,
                                                color: AppColor().info,
                                              ),
                                              const SizedBox(width: 10),
                                              commentController.dateValue[0] ==
                                                      null
                                                  ? Container()
                                                  : InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          commentController
                                                                  .dateValue[
                                                              0] = null;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.close_rounded,
                                                        color: AppColor().info,
                                                        size: 18,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        AppWidget().shortButtonWidget(
                                          text: 'Select Date >>',
                                          fontColor: AppColor().info,
                                          color: AppColor().accent2,
                                          fontSize: 12,
                                          radius: 20,
                                          borderColor: AppColor().info,
                                          action: () {
                                            return AppWidget().customPopup(
                                              context: context,
                                              widget: const Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  DateSinglePicker(),
                                                ],
                                              ),
                                              actionTitle: 'Okay',
                                              action: () {
                                                Get.back();
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  setState(() {
                                                    commentController
                                                        .getValueText(
                                                      commentController
                                                          .config.calendarType,
                                                      commentController
                                                          .dateValue,
                                                    );

                                                    commentController
                                                        .submitData();
                                                  });
                                                });
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Get.arguments['documentType'] == 'search'
                                ? commentSearch()
                                : commentAssigned(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AppWidget().buttonWidget(
                  text: 'Assign',
                  fontColor: AppColor().info,
                  color: AppColor().secondary,
                  borderColor: AppColor().info,
                  action: () {
                    EasyLoading.show(status: 'loading...');
                    if (getStorage.read('roleId') == 'Director') {
                      if (Get.arguments['documentType'] == 'search') {
                        if (assignStaffInSearchController.assigneeId.isEmpty) {
                          Future.delayed(const Duration(seconds: 2), () {
                            EasyLoading.showError(
                              'Missing required field (*).',
                              duration: const Duration(seconds: 2),
                            );
                            AppWidget().errorScackbar(
                              title: 'Required',
                              message: 'Missing required field (*).',
                            );
                            EasyLoading.dismiss();
                          });
                        } else {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            EasyLoading.dismiss();
                            assignStaffInSearchController.docId =
                                Get.arguments['docID'];

                            if (commentController.dateValue[0] != null) {
                              assignStaffInSearchController.reportDate =
                                  commentController.formatDateTime(
                                commentController.dateValue[0]!,
                              );
                            } else {
                              assignStaffInSearchController.reportDate = '';
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  content: Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              color: AppColor().primary,
                                            ),
                                            const SizedBox(width: 4),
                                            AppWidget().textTitle(
                                              title: 'Confirmation',
                                              size: 18,
                                              color: AppColor().primary,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: AppWidget().textNormal(
                                            title:
                                                'Please confirm your acceptance of the assigned task.',
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    AppWidget().shortButtonWidget(
                                      text: 'Cancel',
                                      fontColor: AppColor().primary,
                                      color: AppColor().info,
                                      borderColor: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        Get.back();
                                      },
                                    ),
                                    AppWidget().shortButtonWidget(
                                      text: 'Submit',
                                      fontColor: AppColor().info,
                                      color: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        EasyLoading.show(status: 'loading...');
                                        assignStaffInSearchController
                                            .submitDataFromSearch();
                                        commentController.dateValue[0] = null;
                                        assignStaffInSearchController
                                            .assigneeId = [];
                                        assignStaffInSearchController
                                            .assigneeName = [];
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      } else {
                        if (assignStaffController.assigneeId.isEmpty) {
                          Future.delayed(const Duration(seconds: 2), () {
                            EasyLoading.showError(
                              'Missing required field (*).',
                              duration: const Duration(seconds: 2),
                            );
                            AppWidget().errorScackbar(
                              title: 'Required',
                              message: 'Missing required field (*).',
                            );
                            EasyLoading.dismiss();
                          });
                        } else {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            EasyLoading.dismiss();
                            assignStaffController.docId =
                                Get.arguments['docID'];

                            if (commentController.dateValue[0] != null) {
                              assignStaffController.reportDate =
                                  commentController.formatDateTime(
                                commentController.dateValue[0]!,
                              );
                            } else {
                              assignStaffController.reportDate = '';
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  content: Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              color: AppColor().primary,
                                            ),
                                            const SizedBox(width: 4),
                                            AppWidget().textTitle(
                                              title: 'Confirmation',
                                              size: 18,
                                              color: AppColor().primary,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: AppWidget().textNormal(
                                            title:
                                                'Please confirm your acceptance of the assigned task.',
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    AppWidget().shortButtonWidget(
                                      text: 'Cancel',
                                      fontColor: AppColor().primary,
                                      color: AppColor().info,
                                      borderColor: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        Get.back();
                                      },
                                    ),
                                    AppWidget().shortButtonWidget(
                                      text: 'Submit',
                                      fontColor: AppColor().info,
                                      color: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        EasyLoading.show(status: 'loading...');
                                        assignStaffController.submitData();
                                        commentController.dateValue[0] = null;
                                        assignStaffController.assigneeId = [];
                                        assignStaffController.assigneeName = [];
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      }
                    } else {
                      if (Get.arguments['documentType'] == 'search') {
                        if (assignDocInSearchController.icDept.isEmpty) {
                          Future.delayed(const Duration(seconds: 2), () {
                            EasyLoading.showError(
                              'Missing required field (*).',
                              duration: const Duration(seconds: 2),
                            );
                            AppWidget().errorScackbar(
                              title: 'Required',
                              message: 'Missing required field (*).',
                            );
                            EasyLoading.dismiss();
                          });
                        } else {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            EasyLoading.dismiss();
                            assignDocInSearchController.docId =
                                Get.arguments['docID'];

                            if (commentController.dateValue[0] != null) {
                              assignDocInSearchController.reportDate =
                                  commentController.formatDateTime(
                                commentController.dateValue[0]!,
                              );
                            } else {
                              assignDocInSearchController.reportDate = '';
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  content: Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              color: AppColor().primary,
                                            ),
                                            const SizedBox(width: 4),
                                            AppWidget().textTitle(
                                              title: 'Confirmation',
                                              size: 18,
                                              color: AppColor().primary,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: AppWidget().textNormal(
                                            title:
                                                'Please confirm your acceptance of the assigned task.',
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    AppWidget().shortButtonWidget(
                                      text: 'Cancel',
                                      fontColor: AppColor().primary,
                                      color: AppColor().info,
                                      borderColor: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        Get.back();
                                      },
                                    ),
                                    AppWidget().shortButtonWidget(
                                      text: 'Submit',
                                      fontColor: AppColor().info,
                                      color: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        EasyLoading.show(status: 'loading...');
                                        assignDocInSearchController
                                            .submitData();
                                        assignDocInSearchController.icBOM = '';
                                        assignDocInSearchController.icBOMName =
                                            '';
                                        assignDocInSearchController.coBOM = [];
                                        assignDocInSearchController.coBOMName =
                                            [];
                                        assignDocInSearchController.icDept = [];
                                        assignDocInSearchController.icDeptName =
                                            [];
                                        assignDocInSearchController.coDept = [];
                                        assignDocInSearchController.coDeptName =
                                            [];
                                        commentController.dateValue[0] = null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      } else {
                        if (assignDocController.icDept.isEmpty) {
                          Future.delayed(const Duration(seconds: 2), () {
                            EasyLoading.showError(
                              'Missing required field (*).',
                              duration: const Duration(seconds: 2),
                            );
                            AppWidget().errorScackbar(
                              title: 'Required',
                              message: 'Missing required field (*).',
                            );
                            EasyLoading.dismiss();
                          });
                        } else {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            EasyLoading.dismiss();
                            assignDocController.docId = Get.arguments['docID'];

                            if (commentController.dateValue[0] != null) {
                              assignDocController.reportDate =
                                  commentController.formatDateTime(
                                commentController.dateValue[0]!,
                              );
                            } else {
                              assignDocController.reportDate = '';
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  content: Container(
                                    width: Get.width,
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline_rounded,
                                              color: AppColor().primary,
                                            ),
                                            const SizedBox(width: 4),
                                            AppWidget().textTitle(
                                              title: 'Confirmation',
                                              size: 18,
                                              color: AppColor().primary,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 4),
                                          child: AppWidget().textNormal(
                                            title:
                                                'Please confirm your acceptance of the assigned task.',
                                            size: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    AppWidget().shortButtonWidget(
                                      text: 'Cancel',
                                      fontColor: AppColor().primary,
                                      color: AppColor().info,
                                      borderColor: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        Get.back();
                                      },
                                    ),
                                    AppWidget().shortButtonWidget(
                                      text: 'Submit',
                                      fontColor: AppColor().info,
                                      color: AppColor().primary,
                                      topPad: 10,
                                      bottomPad: 10,
                                      rightPad: 22,
                                      leftPad: 18,
                                      action: () {
                                        EasyLoading.show(status: 'loading...');
                                        assignDocController.submitData();
                                        assignDocController.icBOM = '';
                                        assignDocController.icBOMName = '';
                                        assignDocController.coBOM = [];
                                        assignDocController.coBOMName = [];
                                        assignDocController.icDept = [];
                                        assignDocController.icDeptName = [];
                                        assignDocController.coDept = [];
                                        assignDocController.coDeptName = [];
                                        commentController.dateValue[0] = null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      }
                    }
                  },
                ),
              ],
            )
          : Container();
    });
  }

  checkAssignedRole() {
    return Obx(() {
      return Get.find<CommentController>()
                  .documentDetailResModel
                  .value
                  .errorCode ==
              null
          ? Container()
          : getStorage.read('roleId') == 'CEO' ||
                  commentController.documentDetailResModel.value.documentInfo!
                          .submisssionToBOM ==
                      getStorage.read('username')
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: AppWidget().textTitle(
                        title: 'Board of Manager',
                        size: 15,
                        color: AppColor().info,
                      ),
                    ),
                    inChargeBOM(),
                    coordinateBOM(),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: AppWidget().textTitle(
                        title: 'Department / Branch',
                        size: 15,
                        color: AppColor().info,
                      ),
                    ),
                    inChargeDept(),
                    coordinateDept(),
                  ],
                )
              : getStorage.read('roleId') == 'BOM'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: AppWidget().textTitle(
                            title: 'Department / Branch',
                            size: 15,
                            color: AppColor().info,
                          ),
                        ),
                        inChargeDept(),
                        coordinateDept(),
                      ],
                    )
                  : getStorage.read('roleId') == 'Director'
                      ? directorToStaff()
                      : Container();
    });
  }

  inChargeBOM() {
    final bomItems = bomController.bomResModel;

    return Obx(() {
      return Get.find<BOMController>().bomResModel.value.errorCode == null
          ? Container()
          : Get.arguments['documentType'] == 'search'
              ? Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColor().accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SmartSelect<String?>.single(
                    title: 'Assign In Charge BOM',
                    selectedValue: assignDocInSearchController.icBOM,
                    choiceItems: S2Choice.listFrom(
                      source: bomItems.value.bOM!,
                      value: (index, bomItem) => '${bomItem.bomID}',
                      title: (index, bomItem) => '${bomItem.bomName}',
                    ),
                    modalType: S2ModalType.bottomSheet,
                    modalConfig: const S2ModalConfig(
                      type: S2ModalType.bottomSheet,
                      useFilter: true,
                      maxHeightFactor: .7,
                    ),
                    onChange: (selected) {
                      setState(() {
                        assignDocInSearchController.icBOM = selected.value!;
                        assignDocInSearchController.icBOMName =
                            selected.choice!.title!;
                      });
                    },
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        isTwoLine: true,
                        leading: Container(
                          width: 110,
                          margin: const EdgeInsets.only(top: 3.5),
                          child: AppWidget().textTitle(
                            title: 'In Charge BOM :',
                            size: 13,
                            color: AppColor().info,
                          ),
                        ),
                        title: AppWidget().textNormal(
                          title: 'Select BOM',
                          size: 15,
                          color: AppColor().info,
                        ),
                        value: AppWidget().textNormal(
                          title: assignDocInSearchController.icBOMName.isEmpty
                              ? 'No BOM\'s assign'
                              : assignDocInSearchController.icBOMName,
                          size: 13,
                          color: AppColor().accent1,
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColor().accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SmartSelect<String?>.single(
                    title: 'Assign In Charge BOM',
                    selectedValue: assignDocController.icBOM,
                    choiceItems: S2Choice.listFrom(
                      source: bomItems.value.bOM!,
                      value: (index, bomItem) => '${bomItem.bomID}',
                      title: (index, bomItem) => '${bomItem.bomName}',
                    ),
                    modalType: S2ModalType.bottomSheet,
                    modalConfig: const S2ModalConfig(
                      type: S2ModalType.bottomSheet,
                      useFilter: true,
                      maxHeightFactor: .7,
                    ),
                    onChange: (selected) {
                      setState(() {
                        assignDocController.icBOM = selected.value!;
                        assignDocController.icBOMName = selected.choice!.title!;
                      });
                    },
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        isTwoLine: true,
                        leading: Container(
                          width: 110,
                          margin: const EdgeInsets.only(top: 3.5),
                          child: AppWidget().textTitle(
                            title: 'In Charge BOM :',
                            size: 13,
                            color: AppColor().info,
                          ),
                        ),
                        title: AppWidget().textNormal(
                          title: 'Select BOM',
                          size: 15,
                          color: AppColor().info,
                        ),
                        value: AppWidget().textNormal(
                          title: assignDocController.icBOMName.isEmpty
                              ? 'No BOM\'s assign'
                              : assignDocController.icBOMName,
                          size: 13,
                          color: AppColor().accent1,
                        ),
                        trailing: assignDocController.icBOM.isEmpty
                            ? Icon(
                                CupertinoIcons.forward,
                                color: Colors.grey,
                                size: 20,
                              )
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    assignDocController.icBOM = '';
                                    assignDocController.icBOMName = '';
                                  });
                                },
                                child: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                      );
                    },
                  ),
                );
    });
  }

  coordinateBOM() {
    final bomItems = bomController.bomResModel;

    return Obx(() {
      return Get.find<BOMController>().bomResModel.value.errorCode == null
          ? Container()
          : Get.arguments['documentType'] == 'search'
              ? Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColor().accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SmartSelect.multiple(
                    title: 'Assign Coordinate BOM',
                    selectedValue: assignDocInSearchController.coBOM,
                    onChange: (selected) {
                      setState(() {
                        assignDocInSearchController.coBOM = selected.value;
                        if (selected.title != null) {
                          assignDocInSearchController.coBOMName =
                              selected.title!;
                        }
                      });
                    },
                    choiceType: S2ChoiceType.chips,
                    choiceItems: S2Choice.listFrom(
                      source: bomItems.value.bOM!,
                      value: (index, bomItem) => '${bomItem.bomID}',
                      title: (index, bomItem) => '${bomItem.bomName}',
                    ),
                    choiceStyle: const S2ChoiceStyle(outlined: true),
                    choiceActiveStyle: S2ChoiceStyle(
                      outlined: false,
                      color: AppColor().primary,
                    ),
                    modalConfig: const S2ModalConfig(
                      type: S2ModalType.bottomSheet,
                      useFilter: true,
                      maxHeightFactor: .7,
                      useConfirm: true,
                      confirmLabel: Text('Confirm'),
                    ),
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        isTwoLine: true,
                        leading: Container(
                          margin: const EdgeInsets.only(top: 3),
                          width: 110,
                          child: AppWidget().textTitle(
                            title: 'Coordinate BOM :',
                            size: 12,
                            color: AppColor().info,
                          ),
                        ),
                        title: AppWidget().textNormal(
                          title: 'Select BOM',
                          size: 15,
                          color: AppColor().info,
                        ),
                        value: AppWidget().textNormal(
                          title: assignDocInSearchController.coBOM.isEmpty
                              ? 'No BOM\'s assign'
                              : assignDocInSearchController.coBOM.length == 1
                                  ? '${assignDocInSearchController.coBOM.length} Member'
                                  : '${assignDocInSearchController.coBOM.length} Members',
                          size: 13,
                          color: AppColor().accent1,
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColor().accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SmartSelect.multiple(
                    title: 'Assign Coordinate BOM',
                    selectedValue: assignDocController.coBOM,
                    onChange: (selected) {
                      setState(() {
                        assignDocController.coBOM = selected.value;
                        if (selected.title != null) {
                          assignDocController.coBOMName = selected.title!;
                        }
                      });
                    },
                    choiceType: S2ChoiceType.chips,
                    choiceItems: S2Choice.listFrom(
                      source: bomItems.value.bOM!,
                      value: (index, bomItem) => '${bomItem.bomID}',
                      title: (index, bomItem) => '${bomItem.bomName}',
                    ),
                    choiceStyle: const S2ChoiceStyle(outlined: true),
                    choiceActiveStyle: S2ChoiceStyle(
                      outlined: false,
                      color: AppColor().primary,
                    ),
                    modalConfig: const S2ModalConfig(
                      type: S2ModalType.bottomSheet,
                      useFilter: true,
                      maxHeightFactor: .7,
                      useConfirm: true,
                      confirmLabel: Text('Confirm'),
                    ),
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        isTwoLine: true,
                        leading: Container(
                          margin: const EdgeInsets.only(top: 3),
                          width: 110,
                          child: AppWidget().textTitle(
                            title: 'Coordinate BOM :',
                            size: 12,
                            color: AppColor().info,
                          ),
                        ),
                        title: AppWidget().textNormal(
                          title: 'Select BOM',
                          size: 15,
                          color: AppColor().info,
                        ),
                        value: AppWidget().textNormal(
                          title: assignDocController.coBOM.isEmpty
                              ? 'No BOM\'s assign'
                              : assignDocController.coBOM.length == 1
                                  ? '${assignDocController.coBOM.length} Member'
                                  : '${assignDocController.coBOM.length} Members',
                          size: 13,
                          color: AppColor().accent1,
                        ),
                      );
                    },
                  ),
                );
    });
  }

  inChargeDept() {
    final directorItems = directorController.directorResModel;

    return Obx(() {
      return Get.find<DirectorController>().directorResModel.value.errorCode ==
              null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColor().accent2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SmartSelect.multiple(
                title: 'Assign In Charge Dept/Branch',
                selectedValue: Get.arguments['documentType'] == 'search'
                    ? assignDocInSearchController.icDept
                    : assignDocController.icDept,
                onChange: (selected) {
                  setState(() {
                    Get.arguments['documentType'] == 'search'
                        ? assignDocInSearchController.icDept = selected.value
                        : assignDocController.icDept = selected.value;
                    if (selected.title != null) {
                      Get.arguments['documentType'] == 'search'
                          ? assignDocInSearchController.icDeptName =
                              selected.title!
                          : assignDocController.icDeptName = selected.title!;
                    }
                  });
                },
                choiceType: S2ChoiceType.chips,
                choiceItems: S2Choice.listFrom(
                  source: directorItems.value.unit!,
                  value: (index, directorItem) => '${directorItem.unitID}',
                  title: (index, directorItem) => '${directorItem.unitName}',
                ),
                choiceStyle: const S2ChoiceStyle(outlined: true),
                choiceActiveStyle: S2ChoiceStyle(
                  outlined: false,
                  color: AppColor().primary,
                ),
                modalConfig: const S2ModalConfig(
                  type: S2ModalType.bottomSheet,
                  useFilter: true,
                  maxHeightFactor: .7,
                  useConfirm: true,
                  confirmLabel: Text('Confirm'),
                ),
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
                    leading: Container(
                      margin: const EdgeInsets.only(top: 3),
                      width: 110,
                      child: AppWidget().textTitle(
                        title: 'In Charge Dept/Branch * :',
                        size: 12,
                        color: AppColor().info,
                      ),
                    ),
                    title: AppWidget().textNormal(
                      title: 'Select Dept/Branch',
                      size: 15,
                      color: AppColor().info,
                    ),
                    value: AppWidget().textNormal(
                      title: Get.arguments['documentType'] == 'search'
                          ? assignDocInSearchController.icDept.isEmpty
                              ? 'No dept/branch assign'
                              : assignDocInSearchController.icDept.length == 1
                                  ? '${assignDocInSearchController.icDept.length} Dept/Branch'
                                  : '${assignDocInSearchController.icDept.length} Depts/Branches'
                          : assignDocController.icDept.isEmpty
                              ? 'No dept/branch assign'
                              : assignDocController.icDept.length == 1
                                  ? '${assignDocController.icDept.length} Dept/Branch'
                                  : '${assignDocController.icDept.length} Depts/Branches',
                      size: 13,
                      color: AppColor().accent1,
                    ),
                  );
                },
              ),
            );
    });
  }

  coordinateDept() {
    final directorItems = directorController.directorResModel;

    return Obx(() {
      return Get.find<DirectorController>().directorResModel.value.errorCode ==
              null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColor().accent2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SmartSelect.multiple(
                title: 'Assign Coordinate Dept/Branch',
                selectedValue: Get.arguments['documentType'] == 'search'
                    ? assignDocInSearchController.coDept
                    : assignDocController.coDept,
                onChange: (selected) {
                  setState(() {
                    Get.arguments['documentType'] == 'search'
                        ? assignDocInSearchController.coDept = selected.value
                        : assignDocController.coDept = selected.value;
                    if (selected.title != null) {
                      Get.arguments['documentType'] == 'search'
                          ? assignDocInSearchController.coDeptName =
                              selected.title!
                          : assignDocController.coDeptName = selected.title!;
                    }
                  });
                },
                choiceType: S2ChoiceType.chips,
                choiceItems: S2Choice.listFrom(
                  source: directorItems.value.unit!,
                  value: (index, directorItem) => '${directorItem.unitID}',
                  title: (index, directorItem) => '${directorItem.unitName}',
                ),
                choiceStyle: const S2ChoiceStyle(outlined: true),
                choiceActiveStyle: S2ChoiceStyle(
                  outlined: false,
                  color: AppColor().primary,
                ),
                modalConfig: const S2ModalConfig(
                  type: S2ModalType.bottomSheet,
                  useFilter: true,
                  maxHeightFactor: .7,
                  useConfirm: true,
                  confirmLabel: Text('Confirm'),
                ),
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    isTwoLine: true,
                    leading: Container(
                      margin: const EdgeInsets.only(top: 3),
                      width: 110,
                      child: AppWidget().textTitle(
                        title: 'Coordinate Dept/Branch :',
                        size: 12,
                        color: AppColor().info,
                      ),
                    ),
                    title: AppWidget().textNormal(
                      title: 'Select Dept/Branch',
                      size: 15,
                      color: AppColor().info,
                    ),
                    value: AppWidget().textNormal(
                      title: Get.arguments['documentType'] == 'search'
                          ? assignDocInSearchController.coDept.isEmpty
                              ? 'No dept/branch assign'
                              : assignDocInSearchController.coDept.length == 1
                                  ? '${assignDocInSearchController.coDept.length} Dept/Branch'
                                  : '${assignDocInSearchController.coDept.length} Depts/Branches'
                          : assignDocController.coDept.isEmpty
                              ? 'No dept/branch assign'
                              : assignDocController.coDept.length == 1
                                  ? '${assignDocController.coDept.length} Dept/Branch'
                                  : '${assignDocController.coDept.length} Depts/Branches',
                      size: 13,
                      color: AppColor().accent1,
                    ),
                  );
                },
              ),
            );
    });
  }

  directorToStaff() {
    final staffItems = staffController.staffResModel;

    return Obx(() {
      return Get.find<StaffController>().staffResModel.value.errorCode == null
          ? Container()
          : Get.find<CommentController>()
                      .taskProposalResModel
                      .value
                      .errorCode ==
                  null
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: AppColor().accent2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SmartSelect.multiple(
                    title: 'Assign Staffs',
                    selectedValue: Get.arguments['documentType'] == 'search'
                        ? assignStaffInSearchController.assigneeId
                        : assignStaffController.assigneeId,
                    onChange: (selected) {
                      setState(() {
                        Get.arguments['documentType'] == 'search'
                            ? assignStaffInSearchController.assigneeId =
                                selected.value
                            : assignStaffController.assigneeId = selected.value;
                        if (selected.title != null) {
                          Get.arguments['documentType'] == 'search'
                              ? assignStaffInSearchController.assigneeName =
                                  selected.title!
                              : assignStaffController.assigneeName =
                                  selected.title!;
                        }
                      });
                    },
                    choiceType: S2ChoiceType.chips,
                    choiceItems: S2Choice.listFrom(
                      source: staffItems.value.staff!,
                      value: (index, staffItem) => '${staffItem.username}',
                      title: (index, staffItem) =>
                          '${staffItem.firstName} ${staffItem.lastName}',
                    ),
                    choiceStyle: const S2ChoiceStyle(outlined: true),
                    choiceActiveStyle: S2ChoiceStyle(
                      outlined: false,
                      color: AppColor().primary,
                    ),
                    modalConfig: const S2ModalConfig(
                      type: S2ModalType.bottomSheet,
                      useFilter: true,
                      maxHeightFactor: .7,
                      useConfirm: true,
                      confirmLabel: Text('Confirm'),
                    ),
                    tileBuilder: (context, state) {
                      return S2Tile.fromState(
                        state,
                        isTwoLine: true,
                        leading: Container(
                          margin: const EdgeInsets.only(top: 3),
                          width: 80,
                          child: AppWidget().textTitle(
                            title: 'Staff * :',
                            size: 12,
                            color: AppColor().info,
                          ),
                        ),
                        title: AppWidget().textNormal(
                          title: 'Select Staff',
                          size: 15,
                          color: AppColor().info,
                        ),
                        value: AppWidget().textNormal(
                          title: Get.arguments['documentType'] == 'search'
                              ? assignStaffInSearchController.assigneeId.isEmpty
                                  ? 'No Staff\'s assign'
                                  : assignStaffInSearchController
                                              .assigneeId.length ==
                                          1
                                      ? '${assignStaffInSearchController.assigneeId.length} Staff'
                                      : '${assignStaffInSearchController.assigneeId.length} Staffs'
                              : assignStaffController.assigneeId.isEmpty
                                  ? 'No Staff\'s assign'
                                  : assignStaffController.assigneeId.length == 1
                                      ? '${assignStaffController.assigneeId.length} Staff'
                                      : '${assignStaffController.assigneeId.length} Staffs',
                          size: 13,
                          color: AppColor().accent1,
                        ),
                      );
                    },
                  ),
                );
    });
  }

  commentAssigned() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AppWidget().textTitle(
            title: 'Comment',
            size: 15,
            color: AppColor().info,
          ),
        ),
        TextFormField(
          controller: getStorage.read('roleId') == 'Director'
              ? assignStaffController.commentTextField
              : assignDocController.commentTextField,
          obscureText: false,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            hintText: 'Comment here...',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().primaryText,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: AppColor().info,
          ),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 10,
          minLines: 4,
        ),
      ],
    );
  }

  commentSearch() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AppWidget().textTitle(
            title: 'Comment',
            size: 15,
            color: AppColor().info,
          ),
        ),
        TextFormField(
          controller: getStorage.read('roleId') == 'Director'
              ? assignStaffInSearchController.commentTextField
              : assignDocController.commentTextField,
          obscureText: false,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            hintText: 'Comment here...',
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().primaryText,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor().error,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: AppColor().info,
          ),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 10,
          minLines: 4,
        ),
      ],
    );
  }
}
