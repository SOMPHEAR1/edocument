// ignore_for_file: unused_import

import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';
import '../models/login_model.dart';
import '../screens/auth/login_screen.dart';
import '../services/api/auth/login_service.dart';
import '../services/encryptor/aes_encryption.dart';
import '../services/notification/notification_services.dart';
import '../widget/app_widget.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  NotificationServices notificationServices = NotificationServices();

  late Rx<bool> hidePass = false.obs;
  void passShow() {
    hidePass.toggle();
  }

  late Rx<bool> hidePassExpire = false.obs;
  void passShowExpire() {
    hidePassExpire.toggle();
  }

  LoginService service = LoginService();
  Rx<LoginModel> loginResModel = LoginModel().obs;

  Future<void> submitData() async {
    final res = await service.postAPI(
        emailController.text,
        passwordController.text,
        fcmToken = await FirebaseMessaging.instance.getToken());

    FirebaseMessaging.instance.onTokenRefresh;

    res.fold((left) {
      return;
    }, (right) {
      loginResModel.value = right;
      if (loginResModel.value.errorCode != "0" ||
          loginResModel.value.tokenJWT == null) {
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showError('Login Failed');
          Future.delayed(const Duration(milliseconds: 50), () {
            AppWidget().errorScackbar(
              title: 'Invalid',
              message: '${loginResModel.value.errorDetail}',
            );
          });

          EasyLoading.dismiss();
        });
      } else {
        setToken(token: loginResModel.value.tokenJWT);
        getStorage.write('username', emailController.text);
        getStorage.write('firstName', loginResModel.value.firstName);
        getStorage.write('lastName', loginResModel.value.lastName);
        getStorage.write('roleId', loginResModel.value.roleId);
        getStorage.write('unitId', loginResModel.value.unitId);
        newPublicKey = loginResModel.value.publicKey.toString();
        getStorage.write('publicKey', newPublicKey);

        Future.delayed(const Duration(seconds: 1), () {
          Get.offNamed(
            '/bottomNavBar',
          );
          emailController.clear();
          passwordController.clear();
          EasyLoading.dismiss();
        });
      }
    });
  }

  // set token
  setToken({String? token}) {
    getStorage.write('token', token);
  }

  void storeNewPublicKey(String newPublicKey) {
    getStorage.write('publicKey', newPublicKey);
  }

  // clear token
  clearToken() async {
    storeNewPublicKey(newPublicKey);
    getStorage.remove('token');
  }

  // handle logout action
  void logout() {
    clearToken();
    Get.offAll(() => const LoginScreen());
  }

  // when login is expired
  Future<void> expiredLogin({
    Function()? action,
  }) async {
    final res = await service.postAPI(
      emailController.text,
      passwordController.text,
      fcmToken = await FirebaseMessaging.instance.getToken(),
    );

    FirebaseMessaging.instance.onTokenRefresh;

    res.fold((left) {
      return;
    }, (right) {
      loginResModel.value = right;

      if (loginResModel.value.errorCode != "0" ||
          loginResModel.value.tokenJWT == null) {
        Future.delayed(const Duration(seconds: 2), () {
          EasyLoading.showError('Login Failed');
          Future.delayed(const Duration(milliseconds: 50), () {
            AppWidget().errorScackbar(
              title: 'Invalid',
              message: '${loginResModel.value.errorDetail}',
            );
          });

          EasyLoading.dismiss();
        });
      } else {
        Get.back();
        Future.delayed(const Duration(milliseconds: 100), () {
          setToken(token: loginResModel.value.tokenJWT);
          getStorage.write('username', emailController.text);
          getStorage.write('firstName', loginResModel.value.firstName);
          getStorage.write('lastName', loginResModel.value.lastName);
          getStorage.write('roleId', loginResModel.value.roleId);
          getStorage.write('unitId', loginResModel.value.unitId);
          newPublicKey = loginResModel.value.publicKey.toString();
          getStorage.write('publicKey', newPublicKey);
          action!.call();
          emailController.clear();
          passwordController.clear();
          update();
        });
      }
    });
  }
}
