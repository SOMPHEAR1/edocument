import 'package:get/get.dart';

import '../models/bom_model.dart';
import '../services/api/home/bom_service.dart';
import '../widget/app_widget.dart';

class BOMController extends GetxController {
  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  BOMService service = BOMService();
  Rx<BOMModel> bomResModel = BOMModel().obs;
  var bomID = ''.obs;

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      bomID.value,
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      bomResModel.value = right;
    });
  }
}
