import 'package:get/get.dart';

import '../models/director_model.dart';
import '../services/api/home/director_service.dart';
import '../widget/app_widget.dart';

class DirectorController extends GetxController {
  bool isCheck = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  DirectorService service = DirectorService();
  Rx<DirectorModel> directorResModel = DirectorModel().obs;
  var unitID = ''.obs;
  List<String> list = [];

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      unitID.value,
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      directorResModel.value = right;
    });
  }
}
