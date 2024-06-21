// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/task_document_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import 'task_detail_screen.dart';

class TaskDocumentScreen extends StatefulWidget {
  TaskDocumentScreen({super.key});

  @override
  State<TaskDocumentScreen> createState() => _TaskDocumentScreenState();
}

class _TaskDocumentScreenState extends State<TaskDocumentScreen> {
  final TaskDocumentController taskDocumentController = Get.put(
    TaskDocumentController(
      issuePlace: Get.arguments['issuePlace'],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: Scaffold(
        backgroundColor: AppColor().primary.withOpacity(0.85),
        appBar: AppWidget().customAppBar(),
        body: ListView(
          children: [
            AppWidget().newAppBar(
              title: 'Task',
              context: context,
            ),
            assigned(),
          ],
        ),
      ),
    );
  }

  assigned() {
    final taskItem = taskDocumentController.taskDocumentResModel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
            child: AppWidget().textLargeTitle(
              title: 'Assigned',
              color: AppColor().info,
            ),
          ),
          Obx(() {
            return Get.find<TaskDocumentController>()
                        .taskDocumentResModel
                        .value
                        .errorCode ==
                    null
                ? AppWidget().loadingIndicator()
                : getStorage.read('roleId') == 'Staff'
                    ? taskItem.value.subTask == null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: AppWidget().textTitle(
                              title: 'No Document',
                              color: AppColor().info,
                            ),
                          )
                        : ListView.builder(
                            itemCount: taskItem.value.subTask!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: AppWidget().assignDocItem(
                                  context: context,
                                  docTitle:
                                      '${taskItem.value.subTask![index].documentTitle}',
                                  docNumber:
                                      '${taskItem.value.subTask![index].documentNumber}',
                                  assignDate:
                                      '${taskItem.value.subTask![index].submissionDateTime}',
                                  action: () {
                                    return Get.to(
                                      () => TaskDetailScreen(),
                                      arguments: {
                                        'assignID':
                                            '${taskItem.value.subTask![index].assignmentID}',
                                        'docID':
                                            '${taskItem.value.subTask![index].documentId}',
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          )
                    : taskItem.value.task == null
                        ? Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: AppWidget().textTitle(
                              title: 'No Document',
                              color: AppColor().info,
                            ),
                          )
                        : ListView.builder(
                            itemCount: taskItem.value.task!.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: AppWidget().assignDocItem(
                                    context: context,
                                    docTitle:
                                        '${taskItem.value.task![index].documentTitle}',
                                    assignDate:
                                        '${taskItem.value.task![index].submissionDateTime}',
                                    docNumber:
                                        '${taskItem.value.task![index].documentNumber}',
                                    action: () {
                                      return Get.to(
                                        () => TaskDetailScreen(),
                                        arguments: {
                                          'assignID':
                                              '${taskItem.value.task![index].assignmentID}',
                                          'docID':
                                              '${taskItem.value.task![index].documentId}',
                                        },
                                      );
                                    }),
                              );
                            },
                          );
          }),
        ],
      ),
    );
  }
}
