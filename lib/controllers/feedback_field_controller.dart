// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/feedback_field_model.dart';
import '../models/feedback_model.dart';
import '../services/api/assigned/feedback_field_service.dart';
import '../widget/app_widget.dart';
import 'feedback_controller.dart';
import 'task_document_controller.dart';

class FeedbackFieldController extends GetxController {
  FeedbackFieldController({
    required this.assignmentId,
  });

  final String assignmentId;

  FeedbackFieldService service = FeedbackFieldService();
  Rx<FeedbackFieldModel> feedbackFieldResModel = FeedbackFieldModel().obs;
  Rx<FeedbackModel> feedbackResModel = FeedbackModel().obs;

  final TextEditingController commentTextField = TextEditingController();
  FocusNode commentFocusNode = FocusNode();

  final loading = RxBool(false);
  final comments = RxList<String>();

  String progress = "0";

  String newProgress = "0";
  String? selectedPercent;

  void setProgress(String newProgress) {
    progress = newProgress;
  }

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');
    final res;
    res = await service.postAPI(
      assignmentId,
      commentTextField.text,
      newProgress == "0" ? progress : newProgress,
      token,
      publicKey,
    );

    res.fold(
      (left) {
        return;
      },
      (right) async {
        feedbackFieldResModel.value = right;
        Get.find<TaskDocumentController>().submitTaskData();
        Get.find<FeedbackController>().submitData();
        setProgress(feedbackResModel.value.progress.toString());
        Future.delayed(const Duration(seconds: 1), () {
          EasyLoading.dismiss();
        });
      },
    );
  }
}
