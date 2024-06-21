import 'dart:math';

import 'package:get/get.dart';

import '../models/notification_model.dart';
import '../services/notification/notification_services.dart';
import '../widget/app_widget.dart';

class NotificationController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  NotificationServices service = NotificationServices();
  Rx<NotificationModel> notifyResModel = NotificationModel().obs;

  int visibleItemCount = 6;

  void loadMoreItems(int length) {
    visibleItemCount = min(visibleItemCount + 5, length);
  }

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      notifyResModel.value = right;
    });
    update();
  }
}
