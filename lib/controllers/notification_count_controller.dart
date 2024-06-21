import 'package:get/get.dart';

import '../models/notification_count_model.dart';
import '../services/notification/notification_count_service.dart';
import '../widget/app_widget.dart';

class NotificationCountController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  NotificationCountService service = NotificationCountService();
  Rx<NotificationCountModel> notifyCountResModel = NotificationCountModel().obs;

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
      // print('count: ${notifyCountResModel.value.noOfNewNoti}');
      notifyCountResModel.value = right;
      // print('count new: ${notifyCountResModel.value.noOfNewNoti}');
    });
  }
}
