import 'package:get/get.dart';

import '../models/proposal_detail_model.dart';
import '../services/api/home/proposal_detail_service.dart';
import '../widget/app_widget.dart';

class ProposalDetailController extends GetxController {
  ProposalDetailController({required this.documentID});

  final String documentID;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  ProposalDetailService service = ProposalDetailService();
  Rx<ProposalDetailModel> proposalDetailResModel = ProposalDetailModel().obs;

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postDetailAPI(
      documentID,
      token,
      publicKey,
    );
    res.fold((left) {
      return;
    }, (right) {
      proposalDetailResModel.value = right;
    });
  }
}
