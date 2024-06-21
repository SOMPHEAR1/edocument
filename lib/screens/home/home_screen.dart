// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/notification_count_controller.dart';
import '../../controllers/sub_task_document_controller.dart';
import '../../controllers/task_document_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../assigned/assigned_screen.dart';
import '../notification/notification_screen.dart';
import 'proposal_document_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginController loginController = Get.put(LoginController());
  final HomeController homeController = Get.put(HomeController());

  final TaskDocumentController taskDocumentController = Get.put(
    TaskDocumentController(issuePlace: ''),
  );
  final SubTaskDocumentController subTaskDocumentController = Get.put(
    SubTaskDocumentController(issuePlace: ''),
  );
  final NotificationCountController notificationCountController =
      Get.put(NotificationCountController());

  @override
  Widget build(BuildContext context) {
    final roleId = getStorage.read('roleId');

    return AppWidget().backgroundImage(
      child: Scaffold(
        backgroundColor: AppColor().primary.withOpacity(0.85),
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 90,
          backgroundColor: Colors.transparent,
          title: Obx(
            () => Get.find<NotificationCountController>()
                        .notifyCountResModel
                        .value
                        .errorCode ==
                    null
                ? Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(16, 12, 0, 12),
                    width: Get.width,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColor().accent3,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  )
                : AppWidget().profileLabelForHome(
                    countNotify: notificationCountController
                                .notifyCountResModel.value.noOfNewNoti ==
                            null
                        ? '0'
                        : '${notificationCountController.notifyCountResModel.value.noOfNewNoti}',
                    name:
                        '${homeController.lastName} ${homeController.firstName}',
                    role: homeController.roleID,
                    profileAction: () {
                      homeController.navigateToProfile();
                    },
                    action: () {
                      Get.to(
                        () => NotificationScreen(),
                      );
                    },
                  ),
          ),
        ),
        body: AppWidget().pullRefresh(
          action: () {
            setState(() {
              Get.find<TaskDocumentController>().visibleItemCountTask = 5;
              Get.find<SubTaskDocumentController>().visibleItemCountSub = 5;

              Get.find<TaskDocumentController>().taskFilter = '';
              Get.find<SubTaskDocumentController>().subTaskFilter = '';

              selectedTask = 'All';
              selectedSubTask = 'All';

              homeController.submitData();
              notificationCountController.submitData();
              Get.find<TaskDocumentController>().submitTaskData();
              Get.find<SubTaskDocumentController>().submitSubTaskData();
            });
          },
          child: ListView(
            children: [
              const SizedBox(height: 16),
              roleId == 'CEO'
                  ? ceo()
                  : roleId == 'BOM'
                      ? bom()
                      : roleId == 'Director'
                          ? director()
                          : staff(),
              const SizedBox(height: 110),
            ],
          ),
        ),
      ),
    );
  }

  ceo() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        proposalDoc(),
        subTask(),
      ],
    );
  }

  bom() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        proposalDoc(),
        taskDoc(),
        const SizedBox(height: 16),
        subTask(),
      ],
    );
  }

  director() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        taskDoc(),
        const SizedBox(height: 16),
        subTask(),
      ],
    );
  }

  staff() {
    return taskDoc();
  }

  proposalDoc() {
    final item = homeController.homeResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppWidget().textTitle(
            title: 'Proposal',
            size: 18,
            color: AppColor().info,
          ),
          Obx(() {
            return Get.find<HomeController>().homeResModel.value.errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : item.value.proposal == null
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor().accent3,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: AppWidget().textTitle(
                            title: 'No Proposal Document',
                            color: AppColor().info,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18),
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: item.value.proposal!.length,
                            itemBuilder: (context, index) {
                              return AppWidget().itemGridView(
                                  title:
                                      '${item.value.proposal![index].issuePlace}',
                                  count: int.parse(
                                      '${int.parse('${item.value.proposal![index].noOfNewDoc}')}'),
                                  action: () {
                                    return Get.to(
                                      () => ProposalDocumentScreen(),
                                      arguments: {
                                        'issuePlace':
                                            '${item.value.proposal![index].issuePlace}',
                                        'documentType': 'Proposal',
                                      },
                                    );
                                  });
                            }),
                      );
          }),
        ],
      ),
    );
  }

  bool showMore = false;
  bool selectFilter = false;
  String selectItem = '';
  var noProgress;
  var noFeedback;

  String selectedTask = 'All';
  String selectedSubTask = 'All';

  List<String> listTaskFilter = ['All', 'Late', 'In Progress', 'Completed'];
  List<String> listSubTaskFilter = ['All', 'Late', 'In Progress', 'Completed'];

  taskDoc() {
    final item = taskDocumentController.taskDocumentResModel;

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget().textTitle(
                  title: 'Task',
                  size: 18,
                  color: AppColor().info,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: DropdownButton<String>(
                    value: selectedTask,
                    onChanged: (String? taskValue) {
                      EasyLoading.show(status: 'loading...');
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          selectedTask = taskValue!;
                          if (taskValue == 'All') {
                            taskDocumentController.taskFilter = '';
                          }
                          taskDocumentController.taskFilter = taskValue;
                          taskDocumentController.submitTaskData();
                        });
                      });
                    },
                    underline: Container(),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.filter_list_rounded,
                        color: AppColor().info,
                        size: 20,
                      ),
                    ),
                    style: TextStyle(color: AppColor().info),
                    dropdownColor: AppColor().tertiary,
                    borderRadius: BorderRadius.circular(12),
                    alignment: Alignment.centerRight,
                    items: listTaskFilter
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Get.find<TaskDocumentController>()
                        .taskDocumentResModel
                        .value
                        .errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : item.value.task == null
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor().accent3,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: AppWidget().textTitle(
                            title: 'No Task Assigned',
                            color: AppColor().info,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: min(
                            taskDocumentController.visibleItemCountTask,
                            item.value.task!.length),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppWidget().taskItem(
                            isLate: '${item.value.task![index].isLate}',
                            docTitle:
                                '${item.value.task![index].documentTitle}',
                            number: '${item.value.task![index].documentNumber}',
                            docBy: 'Assigned by',
                            byPerson: '${item.value.task![index].assignerName}',
                            date: '${item.value.task![index].assignedDate}',
                            progress: item.value.task![index].progress == null
                                ? '0'
                                : '${item.value.task![index].progress}',
                            action: () {
                              noFeedback = item
                                          .value.task![index].noOfFeedbacks ==
                                      null
                                  ? '0'
                                  : '${item.value.task![index].noOfFeedbacks}';

                              noProgress =
                                  item.value.task![index].progress == null
                                      ? '0'
                                      : '${item.value.task![index].progress}';
                              Get.to(
                                () => AssignedScreen(),
                                arguments: {
                                  'documentType': 'Task',
                                  'docId':
                                      '${item.value.task![index].documentId}',
                                  'assignmentId':
                                      '${item.value.task![index].assignmentID}',
                                  'assignerName':
                                      '${item.value.task![index].assignerName}'
                                },
                              );
                            },
                          );
                        },
                      ),
            const SizedBox(height: 12),
            item.value.task == null
                ? Container()
                : taskDocumentController.visibleItemCountTask <
                        item.value.task!.length
                    ? GestureDetector(
                        onTap: () {
                          EasyLoading.show(status: 'Loading...');

                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              taskDocumentController
                                  .loadMoreItemsTask(item.value.task!.length);
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

  subTask() {
    final item = subTaskDocumentController.taskDocumentResModel;

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppWidget().textTitle(
                  title: 'Assigned Task',
                  size: 18,
                  color: AppColor().info,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: DropdownButton<String>(
                    value: selectedSubTask,
                    onChanged: (String? newValue) {
                      EasyLoading.show(status: 'loading...');
                      Future.delayed(const Duration(seconds: 1), () {
                        setState(() {
                          selectedSubTask = newValue!;
                          if (newValue == 'All') {
                            subTaskDocumentController.subTaskFilter = '';
                          }
                          subTaskDocumentController.subTaskFilter = newValue;
                          subTaskDocumentController.submitSubTaskData();
                        });
                      });
                    },
                    underline: Container(),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.filter_list_rounded,
                        color: AppColor().info,
                        size: 20,
                      ),
                    ),
                    style: TextStyle(color: AppColor().info),
                    dropdownColor: AppColor().tertiary,
                    borderRadius: BorderRadius.circular(12),
                    alignment: Alignment.centerRight,
                    items: listSubTaskFilter
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Get.find<TaskDocumentController>()
                        .taskDocumentResModel
                        .value
                        .errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : item.value.subTask == null
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColor().accent3,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: AppWidget().textTitle(
                            title: 'No Sub-Task Assigned',
                            color: AppColor().info,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: min(
                            subTaskDocumentController.visibleItemCountSub,
                            item.value.subTask!.length),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return AppWidget().taskItem(
                            isLate: '${item.value.subTask![index].isLate}',
                            docTitle:
                                '${item.value.subTask![index].documentTitle}',
                            number:
                                '${item.value.subTask![index].documentNumber}',
                            docBy: 'Report by',
                            byPerson: getStorage.read('roleId') == 'Director'
                                ? 'Staff: ${item.value.subTask![index].staffName}'
                                : item.value.subTask![index]
                                                .vicePresidentName ==
                                            null &&
                                        item.value.subTask![index]
                                                .coorVicePresidentName ==
                                            null &&
                                        item.value.subTask![index]
                                                .deparmentName ==
                                            null &&
                                        item.value.subTask![index]
                                                .coorDeparmentName ==
                                            null
                                    ? ''
                                    : '${item.value.subTask![index].vicePresidentName == null && item.value.subTask![index].coorVicePresidentName == null ? '' : '   BOM: ${item.value.subTask![index].vicePresidentName == null ? '' : '${item.value.subTask![index].vicePresidentName};'} ${item.value.subTask![index].coorVicePresidentName ?? ''}\n'}   Dept/Branch: ${item.value.subTask![index].deparmentName ?? ''}; ${item.value.subTask![index].coorDeparmentName ?? ''}',
                            date: '${item.value.subTask![index].assignedDate}',
                            progress:
                                item.value.subTask![index].progress == null
                                    ? '0'
                                    : '${item.value.subTask![index].progress}',
                            action: () {
                              Get.to(
                                () => AssignedScreen(),
                                arguments: {
                                  'documentType':
                                      getStorage.read('roleId') == 'CEO'
                                          ? 'Task'
                                          : 'SubTask',
                                  'docId':
                                      '${item.value.subTask![index].documentId}',
                                  'assignmentId':
                                      '${item.value.subTask![index].assignmentID}',
                                  'assignerName':
                                      '${item.value.subTask![index].assignerName}'
                                },
                              );
                            },
                          );
                        },
                      ),
            const SizedBox(height: 12),
            item.value.subTask == null
                ? Container()
                : subTaskDocumentController.visibleItemCountSub <
                        item.value.subTask!.length
                    ? GestureDetector(
                        onTap: () {
                          EasyLoading.show(status: 'Loading...');

                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              subTaskDocumentController
                                  .loadMoreItemsSub(item.value.subTask!.length);
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
}
