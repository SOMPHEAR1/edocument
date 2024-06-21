import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../controllers/login_controller.dart';
import '../../../controllers/update_info_controller.dart';
import '../../../models/update_info_model.dart';
import '../../../widget/app_widget.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class UpdateInfoService {
  Future<dynamic> postTaskAPI(
    String assignmentId,
    String vicePresidentId,
    String vicePresidentName,
    String coorVicePresident,
    String coorVicePresidentName,
    String departmentId,
    String departmentname,
    String coorDepartmentId,
    String coorDepartmentName,
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
        "Header": {"MsgId": updateInfoHeader},
        "Data": {
          "AssignmentId": assignmentId,
          "VicePresidentId": vicePresidentId,
          "VicePresidentName": vicePresidentName,
          "CoorVicePresident": coorVicePresident,
          "CoorVicePresidentName": coorVicePresidentName,
          "DepartmentId": departmentId,
          "Departmentname": departmentname,
          "CoorDepartmentId": coorDepartmentId,
          "CoorDepartmentName": coorDepartmentName,
          "AssignmentText": comment,
          "ReportDate": reportDate
        }
      };
      String convertRequestBody = json.encode(requestBody);
      log(convertRequestBody);

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

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Update from BOM: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(UpdateInfoModel.fromJson(data));
      } else if (response.statusCode == 401) {
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

  Future<dynamic> postSubTaskAPI(
    String assignmentId,
    String assigneeId,
    String assigneename,
    String comment,
    String reportDate,
    String token,
    String publicKey,
  ) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();
      log('Key before: $key');

      // request body
      final requestBody = {
        "Header": {"MsgId": updateInfoHeader},
        "Data": {
          "AssignmentId": assignmentId,
          "AssigneeId": assigneeId,
          "AssigneeName": assigneename,
          "AssignmentText": comment,
          "ReportDate": reportDate
        }
      };
      String convertRequestBody = json.encode(requestBody);

      log('service: $convertRequestBody');

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
      final UpdateInfoController updateInfoController = Get.find();

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(UpdateInfoModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                Future.delayed(const Duration(seconds: 1), () {
                  updateInfoController.submitTaskData();
                  updateInfoController.submitSubTaskData();
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
