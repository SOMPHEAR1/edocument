import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/update_info_model.dart';
import '../services/api/home/update_info_service.dart';
import '../widget/app_widget.dart';
import 'comment_controller.dart';
import 'task_detail_controller.dart';

class UpdateInfoController extends GetxController {
  UpdateInfoController({required this.assignedmentId});

  String assignedmentId;

  String formatDateTime({DateTime? dateTime}) {
    return DateFormat('dd/MM/yyyy').format(dateTime!);
  }

  UpdateInfoService service = UpdateInfoService();
  Rx<UpdateInfoModel> updateInfoResModel = UpdateInfoModel().obs;

  final TaskDetailController taskDetailController = Get.find();
  final CommentController commentController = Get.find();

  String vicePresidentId = '';
  String vicePresidentName = '';
  List<String> coorVicePresident = [];
  List<String> coorVicePresidentName = [];
  List<String> departmentId = [];
  List<String> departmentname = [];
  List<String> coorDepartmentId = [];
  List<String> coorDepartmentName = [];
  TextEditingController commentTaskTextField = TextEditingController(
    text: Get.arguments['comment'] == null || Get.arguments['comment'] == 'null'
        ? ''
        : Get.arguments['comment'],
  );
  var reportDateTask = Get.arguments['reportDate'];

  void submitTaskData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postTaskAPI(
      assignedmentId,
      vicePresidentId,
      vicePresidentName,
      coorVicePresident.map((val) => val.trim()).join('; '),
      coorVicePresidentName.map((val) => val.trim()).join('; '),
      departmentId.map((val) => val.trim()).join('; '),
      departmentname.map((val) => val.trim()).join('; '),
      coorDepartmentId.map((val) => val.trim()).join('; '),
      coorDepartmentName.map((val) => val.trim()).join('; '),
      commentTaskTextField.text.trim(),
      reportDateTask,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      updateInfoResModel.value = right;
      if (updateInfoResModel.value.errorCode.toString() == "0") {
        EasyLoading.show(status: 'loading...');
        Get.back();
        Get.back();
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showSuccess(
            'Assigned Success',
            duration: const Duration(seconds: 2),
          );
          taskDetailController.submitData();
          commentController.submitData();
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.show(status: 'loading...');
        AppWidget().errorScackbar(
          title: 'Error',
          message: updateInfoResModel.value.errorDetail == null
              ? 'Something wrong!'
              : '${updateInfoResModel.value.errorDetail}',
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

  List<String> assigneeId = [];
  List<String> assigneename = [];
  TextEditingController commentSubTaskTextField = TextEditingController(
    text: Get.arguments['comment'] == null || Get.arguments['comment'] == 'null'
        ? ''
        : Get.arguments['comment'],
  );
  var reportDateSubTask = '';

  void submitSubTaskData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postSubTaskAPI(
      assignedmentId,
      assigneeId.map((val) => val.trim()).join('; '),
      assigneename.map((val) => val.trim()).join('; '),
      commentSubTaskTextField.text.trim(),
      reportDateSubTask,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      updateInfoResModel.value = right;
      if (updateInfoResModel.value.errorCode.toString() == "0") {
        EasyLoading.show(status: 'loading...');
        Get.back();
        Get.back();
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showSuccess(
            'Assigned Success',
            duration: const Duration(seconds: 2),
          );
          taskDetailController.submitData();
          commentController.submitData();
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.show(status: 'loading...');
        AppWidget().errorScackbar(
          title: 'Error',
          message: updateInfoResModel.value.errorDetail == null
              ? 'Something wrong!'
              : '${updateInfoResModel.value.errorDetail}',
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
