// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:e_document_app/controllers/history_controller.dart';
import 'package:e_document_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/assign_doc_model.dart';
import '../services/api/home/assign_doc_service.dart';
import '../widget/app_widget.dart';

class AssignDocInSearchController extends GetxController {
  final HomeController homeController = Get.find();
  final HistoryController historyController = Get.find();

  AssignDocumentService service = AssignDocumentService();
  Rx<AssignDocumentModel> assignDocModel = AssignDocumentModel().obs;

  var docId;
  String icBOM = '';
  String icBOMName = '';
  List<String> coBOM = [];
  List<String> coBOMName = [];
  List<String> icDept = [];
  List<String> icDeptName = [];
  List<String> coDept = [];
  List<String> coDeptName = [];
  TextEditingController commentTextField = TextEditingController();
  var reportDate = '';

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postSearchAPI(
      docId,
      icBOM,
      icBOMName,
      coBOM.map((val) => val.trim()).join('; '),
      coBOMName.map((val) => val.trim()).join('; '),
      icDept.map((val) => val.trim()).join('; '),
      icDeptName.map((val) => val.trim()).join('; '),
      coDept.map((val) => val.trim()).join('; '),
      coDeptName.map((val) => val.trim()).join('; '),
      commentTextField.text,
      reportDate,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      assignDocModel.value = right;
      if (assignDocModel.value.errorCode.toString() == "0") {
        Get.back();
        Get.back();
        Future.delayed(const Duration(seconds: 1), () {
          EasyLoading.showSuccess(
            'Assigned Success',
            duration: const Duration(seconds: 2),
          );
          homeController.submitData();
          historyController.submitData();
          EasyLoading.dismiss();
        });
      } else {
        AppWidget().errorScackbar(
          title: 'Error',
          message: assignDocModel.value.errorDetail == null
              ? 'Something wrong!'
              : '${assignDocModel.value.errorDetail}',
        );
        Get.back();
        Future.delayed(const Duration(seconds: 1), () {
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
