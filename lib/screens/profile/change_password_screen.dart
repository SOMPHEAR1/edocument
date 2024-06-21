// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:e_document_app/widget/dismiss_keyboad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

import '../../controllers/change_password_controller.dart';
import '../../widget/app_widget.dart';
import '../../widget/color.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ChangePasswordController changePasswordController =
      Get.put(ChangePasswordController());

  bool isButtonClicked = false;

  @override
  Widget build(BuildContext context) {
    return AppWidget().backgroundImage(
      child: DismissKeyboard(
        child: Scaffold(
          backgroundColor: AppColor().primary.withOpacity(0.85),
          appBar: AppWidget().customAppBar(),
          body: Obx(() {
            return ListView(
              children: [
                appBar(),
                SizedBox(height: Get.height * 0.15),
                Center(
                  child: AppWidget().textTitle(
                    title: 'Change Password',
                    size: 22,
                    color: AppColor().info,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 32),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor().accent3,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          oldPasswordTextField(),
                          newPasswordTextField(),
                          confirmPasswordTextField(),
                        ],
                      ),
                    ),
                  ),
                ),
                AppWidget().buttonWidget(
                  text: 'Confirm',
                  fontColor: AppColor().info,
                  color: AppColor().tertiary,
                  borderColor: AppColor().info,
                  radius: 30,
                  action: () {
                    if (!isButtonClicked) {
                      submitData();
                    }
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TouchRippleEffect(
            onTap: () {
              Get.back();
            },
            backgroundColor: AppColor().accent3,
            rippleColor: Colors.white24,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColor().info,
                  size: 26,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.transparent,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  oldPasswordTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.lock,
              color: AppColor().info,
              size: 24,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: changePasswordController.currentPassTextField,
              focusNode: changePasswordController.currentPassFocusNode,
              obscureText: !changePasswordController.hidecurrentPass.value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                hintText: 'current password',
                hintStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().info,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().tertiary,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () => changePasswordController.currentPassShow(),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Icon(
                    changePasswordController.hidecurrentPass.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor().primaryBackground,
                    size: 20,
                  ),
                ),
              ),
              style: TextStyle(
                color: AppColor().info,
                fontSize: 14,
              ),
              cursorColor: AppColor().info,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(changePasswordController.newPassFocusNode);
              },
            ),
          ),
        ],
      ),
    );
  }

  newPasswordTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.lock_open_rounded,
              color: AppColor().info,
              size: 24,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: changePasswordController.newPassTextField,
              focusNode: changePasswordController.newPassFocusNode,
              obscureText: !changePasswordController.hidenewPass.value,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                hintText: 'new password',
                hintStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().info,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().tertiary,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () => changePasswordController.newPassShow(),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Icon(
                    changePasswordController.hidenewPass.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor().primaryBackground,
                    size: 20,
                  ),
                ),
              ),
              style: TextStyle(
                color: AppColor().info,
                fontSize: 14,
              ),
              cursorColor: AppColor().info,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(
                    changePasswordController.confirmPassFocusNode);
              },
            ),
          ),
        ],
      ),
    );
  }

  confirmPasswordTextField() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(
              Icons.lock_open_rounded,
              color: AppColor().info,
              size: 24,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: changePasswordController.confirmPassTextField,
              focusNode: changePasswordController.confirmPassFocusNode,
              obscureText: !changePasswordController.hideconfirmPass.value,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                hintText: 'confirm password',
                hintStyle: TextStyle(
                  color: AppColor().info,
                  fontSize: 14,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().info,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().tertiary,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColor().error,
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                suffixIcon: InkWell(
                  onTap: () => changePasswordController.confirmPassShow(),
                  focusNode: FocusNode(skipTraversal: true),
                  child: Icon(
                    changePasswordController.hideconfirmPass.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColor().primaryBackground,
                    size: 20,
                  ),
                ),
              ),
              style: TextStyle(
                color: AppColor().info,
                fontSize: 14,
              ),
              cursorColor: AppColor().info,
              onFieldSubmitted: (value) {
                changePasswordController.confirmPassFocusNode.unfocus();
                if (!isButtonClicked) {
                  submitData();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void submitData() async {
    if (changePasswordController.newPassTextField.text.length >= 8) {
      if (changePasswordController.currentPassTextField.text == '' ||
          changePasswordController.newPassTextField.text == '' ||
          changePasswordController.confirmPassTextField.text == '') {
        AppWidget().errorScackbar(
          title: 'Error',
          message: 'Missing Field *!',
        );
      } else if (changePasswordController.confirmPassTextField.text.trim() !=
          changePasswordController.newPassTextField.text.trim()) {
        AppWidget().errorScackbar(
          title: 'Error',
          message: 'New password isn\'t matched!',
        );
      } else if (changePasswordController.newPassTextField.text.trim() ==
          changePasswordController.currentPassTextField.text.trim()) {
        AppWidget().errorScackbar(
          title: 'Error',
          message: 'New password\'s same as current password!',
        );
      } else {
        EasyLoading.show(status: 'Loading...');
        setState(() {
          isButtonClicked = true;
        });
        await changePasswordController.submitData();
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          EasyLoading.dismiss();
          setState(() {
            isButtonClicked = false;
          });
        }
      }
    } else {
      AppWidget().errorScackbar(
        title: 'Error',
        message: 'New password minimum 8 character!',
      );
    }
  }
}
