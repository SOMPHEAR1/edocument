import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../controllers/assign_doc_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../models/assign_doc_model.dart';
import '../../../widget/app_widget.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class AssignDocumentService {
  Future<dynamic> postAPI(
    String docId,
    String icBOM,
    String icBOMName,
    String coBOM,
    String coBOMName,
    String icDept,
    String icDeptName,
    String coDept,
    String coDeptName,
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
          "VicePresidentId": icBOM,
          "VicePresidentName": icBOMName,
          "CoorVicePresident": coBOM,
          "CoorVicePresidentName": coBOMName,
          "DepartmentId": getStorage.read('roleId') == 'Director' ? '' : icDept,
          "Departmentname": icDeptName,
          "CoorDepartmentId": coDept,
          "CoorDepartmentName": coDeptName,
          "AssignmentText": comment,
          "ReportDate": reportDate,
        }
      };
      String convertRequestBody = json.encode(requestBody);

      log('requestBody: $convertRequestBody', name: "Assign Document Request");

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
      final AssignDocController assignDocController =
          Get.put(AssignDocController());

      // check status
      if (response.statusCode == 200) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('$decrypt', name: 'Assigned Document');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(AssignDocumentModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                Future.delayed(const Duration(seconds: 1), () {
                  assignDocController.submitData();
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

  Future<dynamic> postSearchAPI(
    String docId,
    String icBOM,
    String icBOMName,
    String coBOM,
    String coBOMName,
    String icDept,
    String icDeptName,
    String coDept,
    String coDeptName,
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
          "VicePresidentId": icBOM,
          "VicePresidentName": icBOMName,
          "CoorVicePresident": coBOM,
          "CoorVicePresidentName": coBOMName,
          "DepartmentId": getStorage.read('roleId') == 'Director' ? '' : icDept,
          "Departmentname": icDeptName,
          "CoorDepartmentId": coDept,
          "CoorDepartmentName": coDeptName,
          "AssignmentText": comment,
          "ReportDate": reportDate,
        }
      };
      String convertRequestBody = json.encode(requestBody);

      log('requestBody: $convertRequestBody', name: "Assign Document Request");

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
      if (response.statusCode == 200) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('$decrypt', name: 'Assigned Document');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(AssignDocumentModel.fromJson(data));
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
}
