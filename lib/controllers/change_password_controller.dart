import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/change_password_model.dart';
import '../services/api/profile/change_password_service.dart';
import '../widget/app_widget.dart';

class ChangePasswordController extends GetxController {
  ChangePasswordController();

  ChangePasswordService service = ChangePasswordService();
  Rx<ChangePasswordModel> changePasswordResModel = ChangePasswordModel().obs;

  TextEditingController currentPassTextField = TextEditingController();
  TextEditingController newPassTextField = TextEditingController();
  TextEditingController confirmPassTextField = TextEditingController();

  FocusNode currentPassFocusNode = FocusNode();
  FocusNode newPassFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();

  late Rx<bool> hidecurrentPass = false.obs;
  late Rx<bool> hidenewPass = false.obs;
  late Rx<bool> hideconfirmPass = false.obs;

  void currentPassShow() {
    hidecurrentPass.toggle();
  }

  void newPassShow() {
    hidenewPass.toggle();
  }

  void confirmPassShow() {
    hideconfirmPass.toggle();
  }

  Future<void> submitData() async {
    var token = getStorage.read('token');
    var publicKey = getStorage.read('publicKey');

    final res = await service.postAPI(
      currentPassTextField.text,
      newPassTextField.text,
      token,
      publicKey,
    );

    res.fold((left) {
      return;
    }, (right) {
      changePasswordResModel.value = right;
      if (changePasswordResModel.value.errorCode == "1") {
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showError(
            'Change Password Failed',
            duration: const Duration(seconds: 2),
          );
          EasyLoading.dismiss();
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showSuccess(
            'Change Password Success',
            duration: const Duration(seconds: 2),
          );
          Get.back();
          EasyLoading.dismiss();
        });
      }
    });
  }
}
