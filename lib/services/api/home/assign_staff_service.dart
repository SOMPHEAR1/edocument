import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../controllers/assign_staff_controller.dart';
import '../../../controllers/assign_staff_in_search_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../models/assign_staff_model.dart';
import '../../../widget/app_widget.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class AssignStaffService {
  Future<dynamic> postAPI(
    String docId,
    String departmenId,
    String assigneeId,
    String assigneeName,
    String comment,
    String reportDate,
    String token,
    String publicKey,
  ) async {
    log('service');
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": assignInchargeHeader},
        "Data": {
          "DocumentId": docId,
          "DepartmentId": departmenId,
          "AssigneeId": assigneeId,
          "AssigneeName": assigneeName,
          "AssignmentText": comment,
          "ReportDate": reportDate,
        }
      };
      log('Assign Staff: $requestBody');
      String convertRequestBody = json.encode(requestBody);

      // encrypt AES
      final encryptAES = AESEncryption().encryptAES64(
        plainText: convertRequestBody,
        secretKeyBase64Text: key,
      );

      // encrypt RSA
      final encrytRSA = await RSAEncryption().encryptRSA64(
        plainText: key,
        publicKeyStr: publicKey,
      );

      // encode request body
      Map<String, dynamic> requestBodyEncrypt = {
        "q": encryptAES,
        "m": encrytRSA,
      };
      String convertRequestBodyEncrypt = json.encode(requestBodyEncrypt);

      // request response
      final response = await dio.post(
        apiUrl,
        data: convertRequestBodyEncrypt,
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final LoginController loginController = Get.put(LoginController());
      final AssignStaffController assignStaffController = Get.find();

      // check status
      if (response.statusCode == 200) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Assigned Staff: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(AssignStaffModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                Future.delayed(const Duration(seconds: 1), () {
                  assignStaffController.submitData();
                  EasyLoading.dismiss();
                });
              },
            );
          },
        );
        return Left(response.statusMessage);
      } else if (response.statusCode == 403) {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Service have problem!',
        );
        return Left(response.statusMessage);
      } else {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Something wrong!',
        );
        return Left(response.statusMessage);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<dynamic> postInSearchAPI(
    String docId,
    String departmenId,
    String assigneeId,
    String assigneeName,
    String comment,
    String reportDate,
    String token,
    String publicKey,
  ) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": assignInchargeHeader},
        "Data": {
          "DocumentId": docId,
          "DepartmentId": departmenId,
          "AssigneeId": assigneeId,
          "AssigneeName": assigneeName,
          "AssignmentText": comment,
          "ReportDate": reportDate,
        }
      };
      log('Assign Staff: $requestBody');
      String convertRequestBody = json.encode(requestBody);

      // encrypt AES
      final encryptAES = AESEncryption().encryptAES64(
        plainText: convertRequestBody,
        secretKeyBase64Text: key,
      );

      // encrypt RSA
      final encrytRSA = await RSAEncryption().encryptRSA64(
        plainText: key,
        publicKeyStr: publicKey,
      );

      // encode request body
      Map<String, dynamic> requestBodyEncrypt = {
        "q": encryptAES,
        "m": encrytRSA,
      };
      String convertRequestBodyEncrypt = json.encode(requestBodyEncrypt);

      // request response
      final response = await dio.post(
        apiUrl,
        data: convertRequestBodyEncrypt,
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final LoginController loginController = Get.put(LoginController());
      final AssignStaffInSearchController assignStaffInSearchController = Get.find();

      // check status
      if (response.statusCode == 200) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Assigned Staff: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(AssignStaffModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                Future.delayed(const Duration(seconds: 1), () {
                  assignStaffInSearchController.submitDataFromSearch();
                  EasyLoading.dismiss();
                });
              },
            );
          },
        );
        return Left(response.statusMessage);
      } else if (response.statusCode == 403) {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Service have problem!',
        );
        return Left(response.statusMessage);
      } else {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Something wrong!',
        );
        return Left(response.statusMessage);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
