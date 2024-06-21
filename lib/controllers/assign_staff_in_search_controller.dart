import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/assign_staff_model.dart';
import '../services/api/home/assign_staff_service.dart';
import '../widget/app_widget.dart';
import 'history_controller.dart';
import 'home_controller.dart';

class AssignStaffInSearchController extends GetxController {
  final HomeController homeController = Get.find();

  AssignStaffService service = AssignStaffService();
  Rx<AssignStaffModel> assignStaffResModel = AssignStaffModel().obs;

  var docId;

  List<String> assigneeId = [];
  List<String> assigneeName = [];
  TextEditingController commentTextField = TextEditingController();
  var reportDate = '';

  void submitDataFromSearch() async {
    final HistoryController historyController = Get.find();

    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');
    var departmentId = '';

    final res = await service.postInSearchAPI(
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
          historyController.submitData();
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
