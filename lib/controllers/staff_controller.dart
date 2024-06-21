import 'package:get/get.dart';

import '../models/staff_model.dart';
import '../services/api/home/staff_service.dart';
import '../widget/app_widget.dart';

class StaffController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  StaffService service = StaffService();
  Rx<StaffModel> staffResModel = StaffModel().obs;  

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      getStorage.read('unitId'),
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      staffResModel.value = right;
    });
  }
}
