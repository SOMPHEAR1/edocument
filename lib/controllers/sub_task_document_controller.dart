import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/task_document_model.dart';
import '../services/api/home/document_service.dart';
import '../widget/app_widget.dart';
import 'login_controller.dart';

class SubTaskDocumentController extends GetxController {
  SubTaskDocumentController({required this.issuePlace});

  final String issuePlace;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitSubTaskData();
  }

  @override
  void dispose() {
    LoginController().passwordController.clear();
    super.dispose();
  }

  DocumentService service = DocumentService();

  Rx<TaskDocumentModel> taskDocumentResModel = TaskDocumentModel().obs;

  var dateFrom = DateTime.now().subtract(const Duration(days: 365));
  var dateTo = DateTime.now();
  var subTaskFilter = '';

  int visibleItemCountSub = 5;

  String formatDateTime({DateTime? dateTime}) {
    return DateFormat('dd/MM/yyyy').format(dateTime!);
  }

  void loadMoreItemsSub(int length) {
    visibleItemCountSub = min(visibleItemCountSub + 5, length);
  }

  void submitSubTaskData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postTaskAPI(
      issuePlace,
      formatDateTime(dateTime: dateFrom),
      formatDateTime(dateTime: dateTo),
      subTaskFilter,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      taskDocumentResModel.value = right;
      EasyLoading.dismiss();
    });
  }
}
