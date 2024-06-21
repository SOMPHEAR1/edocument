import 'package:get/get.dart';

import '../models/feedback_model.dart';
import '../services/api/assigned/feedback_service.dart';
import '../widget/app_widget.dart';

class FeedbackController extends GetxController {
  FeedbackController({required this.assignmentId});

  String assignmentId;

  @override
  Future<void> onInit() async {
    super.onInit();
    submitData();
  }

  FeedbackService service = FeedbackService();
  Rx<FeedbackModel> feedbackResModel = FeedbackModel().obs;

  void submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      assignmentId,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      feedbackResModel.value = right;
    });
  }
}
