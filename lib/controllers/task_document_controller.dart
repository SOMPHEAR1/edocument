import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/task_document_model.dart';
import '../services/api/home/document_service.dart';
import '../widget/app_widget.dart';
import 'login_controller.dart';

class TaskDocumentController extends GetxController {
  TaskDocumentController({required this.issuePlace});

  final String issuePlace;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitTaskData();
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
  var taskFilter = '';

  int visibleItemCountTask = 5;

  void loadMoreItemsTask(int length) {
    visibleItemCountTask = min(visibleItemCountTask + 5, length);
  }

  String formatDateTime({DateTime? dateTime}) {
    return DateFormat('dd/MM/yyyy').format(dateTime!);
  }

  void submitTaskData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postSubTaskAPI(
      issuePlace,
      formatDateTime(dateTime: dateFrom),
      formatDateTime(dateTime: dateTo),
      taskFilter,
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
