// ignore_for_file: must_be_immutable, unused_local_variable, unnecessary_null_comparison, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/comment_controller.dart';
import '../../controllers/feedback_controller.dart';
import '../../controllers/feedback_field_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/notification_count_controller.dart';
import '../../controllers/task_detail_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';
import '../../widget/dismiss_keyboad.dart';
import '../home/task_detail_screen.dart';
import '../home/view_pdf.dart';

class AssignedScreen extends StatefulWidget {
  AssignedScreen({super.key});

  @override
  State<AssignedScreen> createState() => _AssignedScreenState();
}

class _AssignedScreenState extends State<AssignedScreen> {
  bool isClicked = false;

  final TaskDetailController taskDetailController = Get.put(
    TaskDetailController(assignmentID: Get.arguments['assignmentId']),
  );

  final FeedbackController feedbackController = Get.put(
    FeedbackController(
      assignmentId: Get.arguments['assignmentId'],
    ),
  );

  final FeedbackFieldController feedbackFieldController = Get.put(
    FeedbackFieldController(assignmentId: Get.arguments['assignmentId']),
  );
  String progres = "0";
  @override
  Widget build(BuildContext context) {
    var feedbackItem;
    var taskDetailItem;

    taskDetailItem = taskDetailController.taskDetailResModel;

    return DismissKeyboard(
      child: AppWidget().backgroundImage(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: AppWidget().pullRefresh(
            action: () {
              setState(() {
                feedbackController.submitData();
              });
            },
            child: Obx(() {
              return FutureBuilder(
                  // Replace with the appropriate Future or function that returns a Future
                  future: () async {
                feedbackController.assignmentId = Get.arguments['assignmentId'];
                feedbackItem = feedbackController.feedbackResModel;

                if (await feedbackItem.value.progress != null) {
                  progres = feedbackItem.value.progress;
                  feedbackFieldController.progress = progres;
                  if (feedbackFieldController.newProgress == "0") {
                    feedbackFieldController.newProgress = progres;
                  }
                  progress();
                }
              }(), builder: (context, snapshot) {
                return ListView(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TouchRippleEffect(
                            onTap: () {
                              Get.find<NotificationController>().submitData();
                              Get.find<NotificationCountController>()
                                  .submitData();

                              Future.delayed(const Duration(milliseconds: 100),
                                  () {
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
                            title: Get.arguments['documentType'] == 'SubTask' ||
                                    getStorage.read('roleId') == 'CEO'
                                ? 'Task Assignment'
                                : 'Task',
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
                    Column(
                      children: [
                        TouchRippleEffect(
                          onTap: () async {
                            taskDetailController.submitData();
                            feedbackFieldController.progress =
                                feedbackItem.value.progress;
                            Get.to(
                              () => TaskDetailScreen(),
                              arguments: {
                                'assignID': '${Get.arguments['assignmentId']}',
                                'documentType':
                                    getStorage.read('roleId') == 'CEO'
                                        ? 'Task'
                                        : '${Get.arguments['documentType']}',
                              },
                            );
                          },
                          rippleColor: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColor().info,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Obx(
                              () => Get.find<TaskDetailController>()
                                          .taskDetailResModel
                                          .value
                                          .errorCode ==
                                      null
                                  ? SizedBox(
                                      width: Get.width,
                                      height: 90,
                                    )
                                  : document(
                                      number:
                                          '${taskDetailItem.value.taskInfo!.documentNumber}',
                                      title:
                                          '${taskDetailItem.value.taskInfo!.documentTitle}',
                                      date:
                                          '${taskDetailItem.value.taskInfo!.assignedDate}',
                                      commentCount:
                                          '${feedbackItem.value.totalFeedbacks}',
                                      progressCount:
                                          '${feedbackItem.value.progress}',
                                    ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColor().accent1.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Obx(() {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AppWidget().textTitle(
                                        title: 'Feedbacks',
                                        color: AppColor().info,
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: Get.height * 0.57,
                                    child: Get.find<FeedbackController>()
                                                .feedbackResModel
                                                .value
                                                .errorCode ==
                                            null
                                        ? AppWidget().loadingIndicator()
                                        : feedbackItem.value.feedback == null
                                            ? ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8,
                                                            left: 22),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child:
                                                        AppWidget().textNormal(
                                                      title: 'No Feedbacks',
                                                      color: AppColor().info,
                                                      size: 14,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : ListView.builder(
                                                itemCount: feedbackItem
                                                    .value.feedback!.length,
                                                shrinkWrap: true,
                                                reverse: true,
                                                itemBuilder: (context, index) {
                                                  return AppWidget()
                                                      .feedbackItems(
                                                    userId:
                                                        '${feedbackItem.value.feedback![index].feedbackerId}',
                                                    assignerName: Get.arguments[
                                                        'assignerName'],
                                                    username:
                                                        '${feedbackItem.value.feedback![index].feedbackerName}',
                                                    date:
                                                        '${feedbackItem.value.feedback![index].feedbackDate}',
                                                    comment:
                                                        '${feedbackItem.value.feedback![index].feedbackText}',
                                                    progress:
                                                        '${feedbackItem.value.feedback![index].progress}',
                                                    fileWidget: feedbackItem
                                                                .value
                                                                .feedback![
                                                                    index]
                                                                .file ==
                                                            null
                                                        ? SizedBox(width: 100)
                                                        : SizedBox(
                                                            width: 150,
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              itemCount:
                                                                  feedbackItem
                                                                      .value
                                                                      .feedback![
                                                                          index]
                                                                      .file!
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      idx) {
                                                                return AppWidget()
                                                                    .feedbackFileItem(
                                                                  fileName:
                                                                      '${feedbackItem.value.feedback![index].file![idx].fileName}',
                                                                  userId:
                                                                      '${feedbackItem.value.feedback![index].feedbackerId}',
                                                                  action: () {
                                                                    Get.to(
                                                                      () =>
                                                                          ViewPdfScreen(),
                                                                      arguments: {
                                                                        'fileID':
                                                                            '${feedbackItem.value.feedback![index].file![idx].fileId}',
                                                                        'fileName':
                                                                            '${feedbackItem.value.feedback![index].file![idx].fileName}',
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                  );
                                                },
                                              ),
                                  ),
                                  Get.arguments['documentType'] == 'SubTask' ||
                                          getStorage.read('roleId') == 'CEO' ||
                                          Get.arguments['assignerName'] ==
                                              '${getStorage.read('lastName')} ${getStorage.read('firstName')}'
                                      ? Container()
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: progress(),
                                        ),
                                  comment(
                                    action: () async {
                                      if (!isClicked) {
                                        feedbackFieldController.commentFocusNode
                                            .unfocus();
                                        setState(() {
                                          isClicked = true;
                                        });
                                        EasyLoading.show(status: 'loading...');
                                        if (feedbackFieldController
                                                .commentTextField.text
                                                .trim() ==
                                            "") {
                                          AppWidget().errorScackbar(
                                            title: 'Required',
                                            message:
                                                'Missing required field (*).',
                                          );
                                        } else {
                                          feedbackFieldController.submitData();

                                          feedbackFieldController
                                              .commentTextField
                                              .clear();

                                          if (mounted) {
                                            setState(() {
                                              isClicked = false;
                                            });
                                          }
                                          if (Get.arguments['from'] ==
                                              'search') {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                              Get.find<CommentController>()
                                                  .submitTaskProsal();
                                            });
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              });
            }),
          ),
        ),
      ),
    );
  }

  document({
    required String number,
    required String title,
    required String date,
    required String commentCount,
    required String progressCount,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 0, 18, 0),
                      child: FaIcon(
                        FontAwesomeIcons.fileImport,
                        color: AppColor().primary,
                        size: 28,
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.only(right: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppWidget().textNormal(
                              title: number,
                              color: AppColor().secondary,
                              size: 13,
                            ),
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AppWidget().textNormal(
                                    title: date,
                                    size: 12,
                                    color: AppColor().secondaryText,
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          AppWidget().textNormal(
                                            title: commentCount,
                                            size: 13,
                                            color: AppColor().tertiary,
                                          ),
                                          const SizedBox(width: 2),
                                          FaIcon(
                                            FontAwesomeIcons.solidCommentDots,
                                            color: AppColor().accent1,
                                            size: 14,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 18),
                                      Row(
                                        children: [
                                          AppWidget().textNormal(
                                            title: '$progressCount%',
                                            size: 13,
                                            color: AppColor().error,
                                          ),
                                          Icon(
                                            Icons.av_timer_rounded,
                                            color: AppColor().error,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
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
      ],
    );
  }

  List<String> percent = [
    "10",
    "20",
    "30",
    "40",
    "50",
    "60",
    "70",
    "80",
    "90",
    "100"
  ];

  int selectedPercentIndex = -1;

  List<String> newListProgress(percentage) {
    List<String> newPercent = [];
    for (int i = 0; i < percent.length; i++) {
      if (int.parse(percent[i]) >= int.parse(percentage)) {
        newPercent.add(percent[i]);
      }
    }
    return newPercent;
  }

  progress() {
    final feedbackItem = feedbackController.feedbackResModel;
    final newList = newListProgress(progres);

    return Obx(
      () => Get.find<FeedbackController>().feedbackResModel.value.errorCode ==
              null
          ? Container()
          : SizedBox(
              height: 30,
              width: Get.width,
              child: ListView.builder(
                itemCount: newList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: index == -1 ? 16 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          feedbackFieldController.newProgress = newList[index];
                          feedbackFieldController.setProgress(newList[index]);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        margin: const EdgeInsets.only(
                          right: 6,
                        ),
                        decoration: BoxDecoration(
                          color: feedbackFieldController.newProgress ==
                                  newList[index]
                              ? AppColor().tertiary
                              : AppColor().info,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: feedbackFieldController.newProgress ==
                                    newList[index]
                                ? AppColor().info
                                : AppColor().secondaryText,
                            width: feedbackFieldController.newProgress ==
                                    newList[index]
                                ? 1
                                : 1.5,
                          ),
                        ),
                        child: Center(
                          child: AppWidget().textNormal(
                            title: '${newList[index]}%',
                            color: feedbackFieldController.newProgress ==
                                    newList[index]
                                ? AppColor().info
                                : AppColor().primaryText,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  comment({
    required Function() action,
  }) {
    return Container(
      padding: const EdgeInsets.only(top: 6),
      child: TextFormField(
        controller: feedbackFieldController.commentTextField,
        focusNode: feedbackFieldController.commentFocusNode,
        obscureText: false,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          hintText: 'Say something...',
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor().primaryText,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor().primary,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor().error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor().error,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: AppColor().info,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: isClicked ? Colors.grey : AppColor().primary,
            ),
            onPressed: isClicked
                ? null
                : () async {
                    await action.call();
                  },
          ),
        ),
      ),
    );
  }
}
