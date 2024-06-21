import 'dart:math';

import 'package:get/get.dart';

import '../models/proposal_document_model.dart';
import '../services/api/home/document_service.dart';
import '../widget/app_widget.dart';
import 'login_controller.dart';

class ProposalDocumentController extends GetxController {
  ProposalDocumentController({required this.issuePlace});

  final String issuePlace;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitProposalData();
  }

  @override
  void dispose() {
    LoginController().passwordController.clear();
    super.dispose();
  }

  DocumentService service = DocumentService();

  Rx<ProposalDocumentModel> proposalDocumentResModel =
      ProposalDocumentModel().obs;

  int visibleItemCount = 5;

  void loadMoreItems(int length) {
    visibleItemCount = min(visibleItemCount + 5, length);
  }

  void submitProposalData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postProposalAPI(
      issuePlace,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      proposalDocumentResModel.value = right;
    });
  }
}
