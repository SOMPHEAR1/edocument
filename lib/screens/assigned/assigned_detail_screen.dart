// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../controllers/assigned_controller.dart';
import '../../controllers/feedback_controller.dart';
import '../../controllers/feedback_field_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';

class AssignedDetailScreen extends StatefulWidget {
  AssignedDetailScreen({super.key});

  @override
  State<AssignedDetailScreen> createState() => _AssignedDetailScreenState();
}

class _AssignedDetailScreenState extends State<AssignedDetailScreen> {
  final AssignedController assignedController = Get.put(AssignedController());

  final FeedbackController feedbackController = Get.put(
    FeedbackController(assignmentId: Get.arguments['assignmentId']),
  );

  final FeedbackFieldController feedbackFieldController = Get.put(
    FeedbackFieldController(assignmentId: Get.arguments['assignmentId']),
  );

  final startingPercent = Get.arguments['progress'];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                AppWidget().newAppBar(
                  title: 'Feedbacks',
                  context: context,
                ),
                const SizedBox(height: 8),
                feedback(),
              ],
            ),
          )),
    );
  }

  feedback() {
    final feedbackItem = feedbackController.feedbackResModel;

    return Obx(() {
      return Get.find<FeedbackController>().feedbackResModel.value.errorCode ==
              null
          ? AppWidget().loadingIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.only(top: 22, bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor().accent3,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppWidget().textLargeTitle(
                          title: 'Feedbacks',
                          color: AppColor().info,
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                AppWidget().textNormal(
                                  title: '${feedbackItem.value.totalFeedbacks}',
                                  size: 13,
                                  color: AppColor().info,
                                ),
                                const SizedBox(width: 4),
                                FaIcon(
                                  FontAwesomeIcons.solidCommentDots,
                                  color: AppColor().info,
                                  size: 14,
                                ),
                              ],
                            ),
                            const SizedBox(width: 18),
                            Row(
                              children: [
                                AppWidget().textNormal(
                                  title: '${feedbackItem.value.progress}%',
                                  size: 13,
                                  color: AppColor().info,
                                ),
                                Icon(
                                  Icons.av_timer_rounded,
                                  color: AppColor().info,
                                  size: 15,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: SizedBox(
                      height: Get.height * 0.62,
                      child: feedbackItem.value.feedback == null || 
          feedbackItem.value.feedback!.isEmpty
                          ? Center(
                              child: AppWidget().textTitle(
                                title: 'No Feedback',
                                color: AppColor().info,
                              ),
                            )
                          : CustomMaterialIndicator(
                              onRefresh: () async {
                                setState(
                                    () => feedbackItem.value.feedback!.clear());
                                feedbackController.submitData();
                              },
                              indicatorBuilder: (BuildContext context,
                                  IndicatorController controller) {
                                return LoadingIndicator(
                                  indicatorType:
                                      Indicator.ballClipRotateMultiple,
                                  strokeWidth: 3,
                                  colors: [AppColor().primary],
                                );
                              },
                              durations: const RefreshIndicatorDurations(
                                cancelDuration: Duration(seconds: 2),
                              ),
                              child: ListView.builder(
                                itemCount: feedbackItem.value.feedback!.length,
                                itemBuilder: (context, index) {
                                  return AppWidget().feedbackItems(
                                    username:
                                        '${feedbackItem.value.feedback![index].feedbackerName}',
                                    date:
                                        '${feedbackItem.value.feedback![index].feedbackDate}',
                                    comment:
                                        '${feedbackItem.value.feedback![index].feedbackText}',
                                    progress:
                                        '${feedbackItem.value.feedback![index].progress}',
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: progress(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: comment(
                      action: () {
                        feedbackFieldController.commentFocusNode.unfocus();
                        if (feedbackFieldController
                            .commentTextField.text.isEmpty) {
                          AppWidget().errorScackbar(
                            title: 'Required',
                            message: 'Missing required field (*).',
                          );
                        } else {
                          feedbackFieldController.submitData();

                          setState(() {
                            feedbackFieldController.commentTextField.clear();
                          });
                          // Future.delayed(const Duration(milliseconds: 500), () {
                          showDialog(
                            barrierColor: Colors.transparent,
                            context: Get.context!,
                            builder: (BuildContext context) {
                              Get.back();
                              EasyLoading.show(status: 'loading...');
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                feedbackController.submitData();
                                EasyLoading.dismiss();
                              });

                              return Container();
                            },
                          );
                          // });
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
    });
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

  progress() {
    final filteredPercent = percent
        .where((element) => int.parse(element) >= int.parse(startingPercent))
        .toList();

    return Obx(
      () => Get.find<FeedbackController>().feedbackResModel.value.errorCode ==
              null
          ? Container()
          : SizedBox(
              height: 30,
              width: Get.width,
              child: ListView.builder(
                itemCount: filteredPercent.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final currentPercent = filteredPercent[index];
                  bool isHidden = index < selectedPercentIndex;
                  feedbackFieldController.progress = startingPercent;

                  return Container(
                    margin: EdgeInsets.only(
                      left: index == 0 ? 16 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (!isHidden) {
                          selectedPercentIndex = index;
                          feedbackFieldController.selectedPercent =
                              currentPercent;
                          feedbackController.feedbackResModel.value.progress =
                              feedbackFieldController.selectedPercent;
                          setState(() {});
                        }
                      },
                      child: isHidden
                          ? Container()
                          : Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              margin: EdgeInsets.only(
                                right:
                                    index < filteredPercent.length - 1 ? 6 : 16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor().info,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: AppColor().secondaryText,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: AppWidget().textNormal(
                                  title: '$currentPercent%',
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
              color: AppColor().primary,
            ),
            onPressed: () {
              action.call();
            },
          ),
        ),
      ),
    );
  }
}
