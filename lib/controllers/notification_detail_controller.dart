import 'package:get/get.dart';

import '../models/proposal_detail_model.dart';
import '../services/api/home/proposal_detail_service.dart';
import '../widget/app_widget.dart';

class NotificationDetailController extends GetxController {
  NotificationDetailController({required this.documentID});

  final String documentID;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  ProposalDetailService service = ProposalDetailService();
  Rx<ProposalDetailModel> documentDetailResModel = ProposalDetailModel().obs;

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postDetailAPI(
      documentID,
      token,
      publicKey,
    );
    res.fold((left) => AppWidget().errorScackbar(), (right) {
      documentDetailResModel.value = right;
    });
  }
}
