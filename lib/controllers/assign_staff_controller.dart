// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:e_document_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/assign_staff_model.dart';
import '../services/api/home/assign_staff_service.dart';
import '../widget/app_widget.dart';
import 'sub_task_document_controller.dart';
import 'task_document_controller.dart';

class AssignStaffController extends GetxController {
  AssignStaffController();

  final HomeController homeController = Get.find();

  AssignStaffService service = AssignStaffService();
  Rx<AssignStaffModel> assignStaffResModel = AssignStaffModel().obs;

  var docId;

  List<String> assigneeId = [];
  List<String> assigneeName = [];
  TextEditingController commentTextField = TextEditingController();
  var reportDate = '';

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');
    var departmentId = '';

    final res = await service.postAPI(
      docId,
      departmentId,
      assigneeId.map((val) => val.trim()).join('; '),
      assigneeName.map((val) => val.trim()).join('; '),
      commentTextField.text,
      reportDate,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      assignStaffResModel.value = right;
      if (assignStaffResModel.value.errorCode.toString() == "0") {
        Get.back();
        Get.back();
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showSuccess(
            'Assigned Success',
            duration: const Duration(seconds: 2),
          );
          homeController.submitData();
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.find<TaskDocumentController>().submitTaskData();
            Get.find<SubTaskDocumentController>().submitSubTaskData();
          });
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.show(status: 'loading...');
        AppWidget().errorScackbar(
          title: 'Error',
          message: assignStaffResModel.value.errorDetail == null
              ? 'Something wrong!'
              : '${assignStaffResModel.value.errorDetail}',
        );
        Get.back();
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showError(
            'Assign Failed',
            duration: const Duration(seconds: 2),
          );
          EasyLoading.dismiss();
        });
      }
    });
  }
}
