// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_is_empty, prefer_const_constructors, deprecated_member_use

import 'package:awesome_select/awesome_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/assign_doc_controller.dart';
import '../../controllers/assign_staff_controller.dart';
import '../../controllers/bom_controller.dart';
import '../../controllers/director_controller.dart';
import '../../controllers/staff_controller.dart';
import '../../controllers/task_detail_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/date_picker_staff.dart';
import '../../widget/dismiss_keyboad.dart';
import 'update_info_screen.dart';
import 'view_pdf.dart';

class TaskDetailScreen extends StatefulWidget {
  TaskDetailScreen({super.key});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskDetailController taskDetailController = Get.put(
    TaskDetailController(assignmentID: Get.arguments['assignID']),
  );

  final BOMController bomController = Get.put(BOMController());
  final DirectorController directorController = Get.put(DirectorController());
  final StaffController staffController = Get.put(StaffController());

  final AssignStaffController assignStaffController =
      Get.put(AssignStaffController());
  final AssignDocController assignDocController =
      Get.put(AssignDocController());

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
              AppWidget().newAppBar(
                title: 'Document Detail',
                context: context,
              ),
              Obx(
                () {
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
                },
              ),
              document(),
              SizedBox(height: getStorage.read('roleId') == 'Staff' ? 0 : 16),
              getStorage.read('roleId') == 'Staff'
                  ? Container()
                  : getStorage.read('roleId') == 'CEO' ||
                          Get.arguments['documentType'] == 'Task'
                      ? memberAssigned()
                      : Container(),
              SizedBox(
                  height: getStorage.read('roleId') == 'CEO' ||
                          Get.arguments['documentType'] == 'Task'
                      ? 16
                      : 0),
              getStorage.read('roleId') == 'CEO'
                  ? assignForCEO(context)
                  : getStorage.read('roleId') == 'BOM'
                      ? assignForBOM(context)
                      : assignForDirector(context),
              const SizedBox(height: 28),
              getStorage.read('roleId') == 'Staff' ||
                      Get.arguments['documentType'] == 'SubTask'
                  ? Container()
                  : AppWidget().buttonWidget(
                      text: 'Assign',
                      fontColor: AppColor().info,
                      color: AppColor().secondary,
                      borderColor: AppColor().info,
                      action: () {
                        EasyLoading.show(status: 'loading...');
                        if (getStorage.read('roleId') == 'Director') {
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
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              EasyLoading.dismiss();
                              assignStaffController.docId =
                                  item.value.taskInfo!.documentId;

                              if (taskDetailController.dateValue[0] != null) {
                                assignStaffController.reportDate =
                                    taskDetailController.formatDateTime(
                                        taskDetailController.dateValue[0]!);
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                          EasyLoading.show(
                                              status: 'loading...');
                                          assignStaffController.submitData();
                                          taskDetailController.dateValue[0] =
                                              null;
                                          assignStaffController.assigneeId = [];
                                          assignStaffController.assigneeName =
                                              [];
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
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              EasyLoading.dismiss();
                              assignDocController.docId =
                                  item.value.taskInfo!.documentId;

                              if (taskDetailController.dateValue[0] != null) {
                                assignDocController.reportDate =
                                    taskDetailController.formatDateTime(
                                        taskDetailController.dateValue[0]!);
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
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                          EasyLoading.show(
                                              status: 'loading...');
                                          assignDocController.submitTaskData();
                                          assignDocController.icBOM = '';
                                          assignDocController.icBOMName = '';
                                          assignDocController.coBOM = [];
                                          assignDocController.coBOMName = [];
                                          assignDocController.icDept = [];
                                          assignDocController.icDeptName = [];
                                          assignDocController.coDept = [];
                                          assignDocController.coDeptName = [];
                                          taskDetailController.dateValue[0] =
                                              null;
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                          }
                        }
                      },
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
              title: 'Attachment',
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
                                              '${item.value.taskInfo!.listOfFiles![index].fileId}',
                                          'fileName':
                                              '${item.value.taskInfo!.listOfFiles![index].fileName}',
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

  memberAssigned() {
    final item = taskDetailController.taskDetailResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.only(
          top: getStorage.read('roleId') == 'BOM' ||
                  getStorage.read('roleId') == 'CEO'
              ? 12
              : 22,
          bottom: 12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget().textLargeTitle(
                  title: 'Member\'s Assigned',
                  color: AppColor().info,
                ),
                Obx(() {
                  return Get.find<TaskDetailController>()
                              .taskDetailResModel
                              .value
                              .errorCode ==
                          null
                      ? Container()
                      : getStorage.read('roleId') == 'CEO'
                          ? AppWidget().iconButtonWidget(
                              icon: FontAwesomeIcons.solidEdit,
                              iconColor: AppColor().info,
                              iconSize: 22,
                              action: () {
                                Get.to(
                                  () => UpdateInfoScreen(),
                                  arguments: {
                                    'docID':
                                        '${item.value.taskInfo!.documentId}',
                                    'assignmentId':
                                        '${item.value.taskInfo!.assignmentId}',
                                    'reportDate':
                                        '${item.value.taskInfo!.reportDate}',
                                    'icBOM':
                                        '${item.value.taskInfo!.vicePresidentId}',
                                    'coorBOM':
                                        '${item.value.taskInfo!.coorVicePresidentId}',
                                    'icDept':
                                        '${item.value.taskInfo!.deparmentId}',
                                    'coorDept':
                                        '${item.value.taskInfo!.coorDeparmentId}',
                                    'staff':
                                        '${item.value.taskInfo!.assigneeId}',
                                    'comment':
                                        '${item.value.taskInfo!.assignmentText}',
                                  },
                                );
                              })
                          : Container();
                }),
              ],
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
                          item.value.taskInfo!.vicePresidentName == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'In Charge BOM :',
                                  member:
                                      '${item.value.taskInfo!.vicePresidentName}',
                                ),
                          item.value.taskInfo!.coorVicePresidentName == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'Coordinate BOM :',
                                  member:
                                      '${item.value.taskInfo!.coorVicePresidentName}',
                                ),
                          item.value.taskInfo!.departmentName == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'In Charge Dept/Branch :',
                                  member:
                                      '${item.value.taskInfo!.departmentName}',
                                ),
                          item.value.taskInfo!.coorDepartmentName == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'Coordinate Dept/Branch :',
                                  member:
                                      '${item.value.taskInfo!.coorDepartmentName}',
                                ),
                          item.value.taskInfo!.reportDate == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'Assigned Date :',
                                  member:
                                      '${item.value.taskInfo!.assignedDate}',
                                ),
                          item.value.taskInfo!.reportDate == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'Report Date :',
                                  member: '${item.value.taskInfo!.reportDate}',
                                ),
                          item.value.taskInfo!.assignmentText == null
                              ? Container()
                              : AppWidget().detailAssignMember(
                                  title: 'Comment :',
                                  member:
                                      '${item.value.taskInfo!.assignmentText}',
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

  assignForDirector(BuildContext context) {
    final staffItems = staffController.staffResModel;
    final taskItem = taskDetailController.taskDetailResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 14, bottom: 12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget().textLargeTitle(
                  title: 'Assign To',
                  color: AppColor().info,
                ),
                Obx(() {
                  return Get.find<TaskDetailController>()
                              .taskDetailResModel
                              .value
                              .errorCode ==
                          null
                      ? Container()
                      : Get.arguments['documentType'] != 'Task'
                          ? AppWidget().iconButtonWidget(
                              icon: FontAwesomeIcons.solidEdit,
                              iconColor: AppColor().info,
                              iconSize: 22,
                              action: () {
                                Get.to(
                                  () => UpdateInfoScreen(),
                                  arguments: {
                                    'docID':
                                        '${taskItem.value.taskInfo!.documentId}',
                                    'assignmentId':
                                        '${taskItem.value.taskInfo!.assignmentId}',
                                    'reportDate':
                                        '${taskItem.value.taskInfo!.reportDate}',
                                    'icBOM':
                                        '${taskItem.value.taskInfo!.vicePresidentId}',
                                    'coorBOM':
                                        '${taskItem.value.taskInfo!.coorVicePresidentId}',
                                    'icDept':
                                        '${taskItem.value.taskInfo!.deparmentId}',
                                    'coorDept':
                                        '${taskItem.value.taskInfo!.coorDeparmentId}',
                                    'staff':
                                        '${taskItem.value.taskInfo!.assigneeId}',
                                    'comment':
                                        '${taskItem.value.taskInfo!.assignmentText}',
                                  },
                                );
                              })
                          : Container();
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Get.find<StaffController>()
                              .staffResModel
                              .value
                              .errorCode ==
                          null
                      ? Container()
                      : Get.find<TaskDetailController>()
                                  .taskDetailResModel
                                  .value
                                  .errorCode ==
                              null
                          ? Container()
                          : Get.arguments['documentType'] == 'SubTask' ||
                                  getStorage.read('roleId') == 'Staff'
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    children: [
                                      AppWidget().textNormal(
                                        title: 'Staff :',
                                        color: AppColor().info,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AppWidget().textTitle(
                                          title:
                                              '${taskItem.value.taskInfo!.assigneeName}',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    color: AppColor().accent2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SmartSelect.multiple(
                                    title: 'Assign Staffs',
                                    selectedValue:
                                        assignStaffController.assigneeId,
                                    onChange: (selected) {
                                      setState(() {
                                        assignStaffController.assigneeId =
                                            selected.value;
                                        if (selected.title != null) {
                                          assignStaffController.assigneeName =
                                              selected.title!;
                                        }
                                      });
                                    },
                                    choiceType: S2ChoiceType.chips,
                                    choiceItems: S2Choice.listFrom(
                                      source: staffItems.value.staff!,
                                      value: (index, staffItem) =>
                                          '${staffItem.username}',
                                      title: (index, staffItem) =>
                                          '${staffItem.firstName} ${staffItem.lastName}',
                                    ),
                                    choiceStyle:
                                        const S2ChoiceStyle(outlined: true),
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
                                          title: assignStaffController
                                                  .assigneeId.isEmpty
                                              ? 'No Staff\'s assign'
                                              : assignStaffController
                                                          .assigneeId.length ==
                                                      1
                                                  ? '${assignStaffController.assigneeId.length} Staff'
                                                  : '${assignStaffController.assigneeId.length} Staffs',
                                          size: 13,
                                          color: AppColor().accent1,
                                        ),
                                      );
                                    },
                                  ),
                                );
                }),
                Obx(
                  () {
                    return Get.find<TaskDetailController>()
                                .taskDetailResModel
                                .value
                                .errorCode ==
                            null
                        ? AppWidget().loadingIndicator()
                        : getStorage.read('roleId') == 'Staff' ||
                                Get.arguments['documentType'] == 'SubTask'
                            ? taskItem.value.taskInfo!.reportDate == null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        AppWidget().textNormal(
                                          title: 'Report Date:',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 12),
                                        AppWidget().textTitle(
                                          title:
                                              '${taskItem.value.taskInfo!.reportDate}',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  )
                            : Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColor().accent2,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(top: 3),
                                          width: 110,
                                          child: AppWidget().textTitle(
                                            title: 'Report Date:',
                                            size: 12,
                                            color: AppColor().info,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8),
                                                child: Row(
                                                  children: [
                                                    AppWidget().textNormal(
                                                      title: taskDetailController
                                                                      .dateValue[
                                                                  0] ==
                                                              null
                                                          ? 'Select date'
                                                          : taskDetailController
                                                              .formatDateTime(
                                                              taskDetailController
                                                                  .dateValue[0]!,
                                                            ),
                                                      size: 14,
                                                      color: AppColor().info,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    taskDetailController
                                                                .dateValue[0] ==
                                                            null
                                                        ? Container()
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                taskDetailController
                                                                        .dateValue[
                                                                    0] = null;
                                                              });
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .close_rounded,
                                                              color: AppColor()
                                                                  .info,
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
                                                  return AppWidget()
                                                      .customPopup(
                                                          context: context,
                                                          widget: const Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              DateSinglePickerStaff(),
                                                            ],
                                                          ),
                                                          actionTitle: 'Okay',
                                                          action: () {
                                                            Get.back();
                                                            Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                                () {
                                                              setState(() {
                                                                taskDetailController
                                                                    .getValueText(
                                                                  taskDetailController
                                                                      .config
                                                                      .calendarType,
                                                                  taskDetailController
                                                                      .dateValue,
                                                                );
                                                                taskDetailController
                                                                    .submitData();
                                                              });
                                                            });
                                                          });
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                  },
                ),
                Obx(
                  () {
                    return Get.find<TaskDetailController>()
                                .taskDetailResModel
                                .value
                                .errorCode ==
                            null
                        ? AppWidget().loadingIndicator()
                        : getStorage.read('roleId') == 'Staff' ||
                                Get.arguments['documentType'] == 'SubTask'
                            ? taskItem.value.taskInfo!.assignmentText == null ||
                                    taskItem.value.taskInfo!.assignmentText ==
                                        'null'
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        AppWidget().textNormal(
                                          title: 'Comment :',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: AppWidget().textTitle(
                                            title:
                                                '${taskItem.value.taskInfo!.assignmentText}',
                                            color: AppColor().info,
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                            : comment();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  assignForBOM(BuildContext context) {
    final directorItems = directorController.directorResModel;
    final taskItem = taskDetailController.taskDetailResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(top: 12, bottom: 12),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget().textLargeTitle(
                  title: 'Assign To',
                  color: AppColor().info,
                ),
                Obx(() {
                  return Get.find<TaskDetailController>()
                              .taskDetailResModel
                              .value
                              .errorCode ==
                          null
                      ? Container()
                      : Get.arguments['documentType'] == 'SubTask'
                          ? AppWidget().iconButtonWidget(
                              icon: FontAwesomeIcons.solidEdit,
                              iconColor: AppColor().info,
                              iconSize: 22,
                              action: () {
                                Get.to(
                                  () => UpdateInfoScreen(),
                                  arguments: {
                                    'docID':
                                        '${taskItem.value.taskInfo!.documentId}',
                                    'assignmentId':
                                        '${taskItem.value.taskInfo!.assignmentId}',
                                    'reportDate':
                                        '${taskItem.value.taskInfo!.reportDate}',
                                    'icBOM':
                                        '${taskItem.value.taskInfo!.vicePresidentId}',
                                    'coorBOM':
                                        '${taskItem.value.taskInfo!.coorVicePresidentId}',
                                    'icDept':
                                        '${taskItem.value.taskInfo!.deparmentId}',
                                    'coorDept':
                                        '${taskItem.value.taskInfo!.coorDeparmentId}',
                                    'staff':
                                        '${taskItem.value.taskInfo!.assigneeId}',
                                    'comment':
                                        '${taskItem.value.taskInfo!.assignmentText}',
                                  },
                                );
                              })
                          : Container();
                }),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Get.arguments['documentType'] == 'SubTask'
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: AppWidget().textTitle(
                          title: 'Department / Branch',
                          size: 15,
                          color: AppColor().info,
                        ),
                      ),
                Obx(() {
                  return Get.find<TaskDetailController>()
                              .taskDetailResModel
                              .value
                              .errorCode ==
                          null
                      ? Container()
                      : Get.arguments['documentType'] == 'SubTask'
                          ? taskItem.value.taskInfo!.departmentName == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    children: [
                                      AppWidget().textNormal(
                                        title: 'In Charge Dept/Branch :',
                                        color: AppColor().info,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AppWidget().textTitle(
                                          title:
                                              '${taskItem.value.taskInfo!.departmentName}',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : directorItems.value.unit == null
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    color: AppColor().accent2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SmartSelect.multiple(
                                    title: 'Assign In Charge Dept/Branch',
                                    selectedValue: assignDocController.icDept,
                                    onChange: (selected) {
                                      setState(() {
                                        assignDocController.icDept =
                                            selected.value;
                                        if (selected.title != null) {
                                          assignDocController.icDeptName =
                                              selected.title!;
                                        }
                                      });
                                    },
                                    choiceType: S2ChoiceType.chips,
                                    choiceItems: S2Choice.listFrom(
                                      source: directorItems.value.unit!,
                                      value: (index, directorItem) =>
                                          '${directorItem.unitID}',
                                      title: (index, directorItem) =>
                                          '${directorItem.unitName}',
                                    ),
                                    choiceStyle:
                                        const S2ChoiceStyle(outlined: true),
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
                                            title: 'In Charge Dept/Branch *:',
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
                                          title: assignDocController
                                                  .icDept.isEmpty
                                              ? 'No dept/branch assign'
                                              : assignDocController
                                                          .icDept.length ==
                                                      1
                                                  ? '${assignDocController.icDept.length} Dept/Branch'
                                                  : '${assignDocController.icDept.length} Depts/Branches',
                                          size: 13,
                                          color: AppColor().accent1,
                                        ),
                                      );
                                    },
                                  ),
                                );
                }),
                Obx(() {
                  return Get.find<TaskDetailController>()
                              .taskDetailResModel
                              .value
                              .errorCode ==
                          null
                      ? Container()
                      : Get.arguments['documentType'] == 'SubTask'
                          ? taskItem.value.taskInfo!.coorDepartmentName == null
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    children: [
                                      AppWidget().textNormal(
                                        title: 'Coordinate Dept/Branch :',
                                        color: AppColor().info,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: AppWidget().textTitle(
                                          title:
                                              '${taskItem.value.taskInfo!.coorDepartmentName}',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                          : directorItems.value.unit == null
                              ? Container()
                              : Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    color: AppColor().accent2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: SmartSelect.multiple(
                                    title: 'Assign Coordinate Dept/Branch',
                                    selectedValue: assignDocController.coDept,
                                    onChange: (selected) {
                                      setState(() {
                                        assignDocController.coDept =
                                            selected.value;
                                        if (selected.title != null) {
                                          assignDocController.coDeptName =
                                              selected.title!;
                                        }
                                      });
                                    },
                                    choiceType: S2ChoiceType.chips,
                                    choiceItems: S2Choice.listFrom(
                                      source: directorItems.value.unit!,
                                      value: (index, directorItem) =>
                                          '${directorItem.unitID}',
                                      title: (index, directorItem) =>
                                          '${directorItem.unitName}',
                                    ),
                                    choiceStyle:
                                        const S2ChoiceStyle(outlined: true),
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
                                            title: 'Coordinate Dept/Branch:',
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
                                          title: assignDocController
                                                  .coDept.isEmpty
                                              ? 'No dept/branch assign'
                                              : assignDocController
                                                          .coDept.length ==
                                                      1
                                                  ? '${assignDocController.coDept.length} Dept/Branch'
                                                  : '${assignDocController.coDept.length} Depts/Branches',
                                          size: 13,
                                          color: AppColor().accent1,
                                        ),
                                      );
                                    },
                                  ),
                                );
                }),
                Get.arguments['documentType'] == 'SubTask'
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: AppWidget().textTitle(
                          title: 'Report',
                          size: 15,
                          color: AppColor().info,
                        ),
                      ),
                Get.arguments['documentType'] == 'SubTask'
                    ? Obx(() {
                        return Get.find<TaskDetailController>()
                                    .taskDetailResModel
                                    .value
                                    .errorCode ==
                                null
                            ? Container()
                            : taskItem.value.taskInfo!.reportDate == null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        AppWidget().textNormal(
                                          title: 'Report Date :',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: AppWidget().textTitle(
                                            title:
                                                '${taskItem.value.taskInfo!.reportDate}',
                                            color: AppColor().info,
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                      })
                    : Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor().accent2,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Get.arguments['documentType'] == 'SubTask'
                                ? Container()
                                : Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Row(
                                      children: [
                                        AppWidget().textNormal(
                                          title: taskDetailController
                                                      .dateValue[0] ==
                                                  null
                                              ? 'Select date'
                                              : taskDetailController
                                                  .formatDateTime(
                                                  taskDetailController
                                                      .dateValue[0]!,
                                                ),
                                          size: 14,
                                          color: AppColor().info,
                                        ),
                                        const SizedBox(width: 10),
                                        taskDetailController.dateValue[0] ==
                                                null
                                            ? Container()
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    taskDetailController
                                                        .dateValue[0] = null;
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
                                              DateSinglePickerStaff(),
                                            ],
                                          ),
                                          actionTitle: 'Okay',
                                          action: () {
                                            Get.back();
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              setState(() {
                                                taskDetailController
                                                    .getValueText(
                                                  taskDetailController
                                                      .config.calendarType,
                                                  taskDetailController
                                                      .dateValue,
                                                );
                                                taskDetailController
                                                    .submitData();
                                              });
                                            });
                                          });
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                Get.arguments['documentType'] == 'SubTask'
                    ? Obx(() {
                        return Get.find<TaskDetailController>()
                                    .taskDetailResModel
                                    .value
                                    .errorCode ==
                                null
                            ? Container()
                            : taskItem.value.taskInfo!.assignmentText == null ||
                                    taskItem.value.taskInfo!.assignmentText ==
                                        'null'
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        AppWidget().textNormal(
                                          title: 'Comment :',
                                          color: AppColor().info,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: AppWidget().textTitle(
                                            title:
                                                '${taskItem.value.taskInfo!.assignmentText}',
                                            color: AppColor().info,
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                      })
                    : comment(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  assignForCEO(BuildContext context) {
    final bomItems = bomController.bomResModel;
    final directorItems = directorController.directorResModel;

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
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
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
                Obx(() {
                  return Get.find<BOMController>()
                              .bomResModel
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
                                assignDocController.icBOMName =
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
                                    title: 'In Charge BOM:',
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
                }),
                Obx(() {
                  return Get.find<BOMController>()
                              .bomResModel
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
                            title: 'Assign Coordinate BOM',
                            selectedValue: assignDocController.coBOM,
                            onChange: (selected) {
                              setState(() {
                                assignDocController.coBOM = selected.value;
                                if (selected.title != null) {
                                  assignDocController.coBOMName =
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
                                    title: 'Coordinate BOM:',
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
                }),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: AppWidget().textTitle(
                    title: 'Department / Branch',
                    size: 15,
                    color: AppColor().info,
                  ),
                ),
                Obx(() {
                  return Get.find<DirectorController>()
                              .directorResModel
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
                            title: 'Assign In Charge Dept/Branch',
                            selectedValue: assignDocController.icDept,
                            onChange: (selected) {
                              setState(() {
                                assignDocController.icDept = selected.value;
                                if (selected.title != null) {
                                  assignDocController.icDeptName =
                                      selected.title!;
                                }
                              });
                            },
                            choiceType: S2ChoiceType.chips,
                            choiceItems: S2Choice.listFrom(
                              source: directorItems.value.unit!,
                              value: (index, directorItem) =>
                                  '${directorItem.unitID}',
                              title: (index, directorItem) =>
                                  '${directorItem.unitName}',
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
                                    title: 'In Charge Dept/Branch *:',
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
                                  title: assignDocController.icDept.isEmpty
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
                }),
                Obx(() {
                  return Get.find<DirectorController>()
                              .directorResModel
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
                            title: 'Assign Coordinate Dept/Branch',
                            selectedValue: assignDocController.coDept,
                            onChange: (selected) {
                              setState(() {
                                assignDocController.coDept = selected.value;
                                if (selected.title != null) {
                                  assignDocController.coDeptName =
                                      selected.title!;
                                }
                              });
                            },
                            choiceType: S2ChoiceType.chips,
                            choiceItems: S2Choice.listFrom(
                              source: directorItems.value.unit!,
                              value: (index, directorItem) =>
                                  '${directorItem.unitID}',
                              title: (index, directorItem) =>
                                  '${directorItem.unitName}',
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
                                    title: 'Coordinate Dept/Branch:',
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
                                  title: assignDocController.coDept.isEmpty
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
                }),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  AppWidget().textNormal(
                                    title: taskDetailController.dateValue[0] ==
                                            null
                                        ? 'Select date'
                                        : taskDetailController.formatDateTime(
                                            taskDetailController.dateValue[0]!,
                                          ),
                                    size: 14,
                                    color: AppColor().info,
                                  ),
                                  const SizedBox(width: 10),
                                  taskDetailController.dateValue[0] == null
                                      ? Container()
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              taskDetailController
                                                  .dateValue[0] = null;
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
                                        DateSinglePickerStaff(),
                                      ],
                                    ),
                                    actionTitle: 'Okay',
                                    action: () {
                                      Get.back();
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        setState(() {
                                          taskDetailController.getValueText(
                                            taskDetailController
                                                .config.calendarType,
                                            taskDetailController.dateValue,
                                          );
                                          taskDetailController.submitData();
                                        });
                                      });
                                    });
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                comment(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  comment() {
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
}
