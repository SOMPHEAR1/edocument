import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/home_controller.dart';
import '../../../controllers/notification_count_controller.dart';
import '../../../controllers/proposal_document_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/sub_task_document_controller.dart';
import '../../../controllers/task_document_controller.dart';
import '../../../models/proposal_document_model.dart';
import '../../../models/task_document_model.dart';
import '../../../widget/app_widget.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class DocumentService {
  Future<dynamic> postProposalAPI(
    String issuPlace,
    String token,
    String publicKey,
  ) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();
      var dateFrom = DateTime.now().subtract(const Duration(days: 365));
      var dateTo = DateTime.now();

      // request body
      final requestBody = {
        "Header": {"MsgId": docProposalHeader},
        "Data": {
          "IssuePlace": issuPlace,
          "DateFrom": formatDateTime(dateTime: dateFrom),
          "DateTo": formatDateTime(dateTime: dateTo)
        }
      };
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

      final LoginController loginController = Get.find();
      final ProposalDocumentController documentController = Get.find();
      final SubTaskDocumentController subTaskDocumentController = Get.find();

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);

        log('Proposal Document: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);
        return Right(ProposalDocumentModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                documentController.submitProposalData();
                Future.delayed(const Duration(seconds: 1), () {
                  documentController.submitProposalData();
                  subTaskDocumentController.submitSubTaskData();
                  EasyLoading.dismiss();
                });
              },
            );
            EasyLoading.dismiss();
          },
        );
        return Left(response.statusMessage);
      } else if (response.statusCode == 403) {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Service have problem!',
        );
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

  Future<dynamic> postTaskAPI(
    String issuPlace,
    String dateFrom,
    String dateTo,
    String filter,
    String token,
    String publicKey,
  ) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": docTaskHeader},
        "Data": {
          "Type": "",
          "IssuePlace": issuPlace,
          "DateFrom": dateFrom,
          "DateTo": dateTo,
          "TaskFilter": filter,
        }
      };
      String convertRequestBody = json.encode(requestBody);
      log('Request: $convertRequestBody');

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

      final LoginController loginController = Get.find();
      final HomeController homeController = Get.find();
      final NotificationCountController notificationCountController =
          Get.find();
      final TaskDocumentController documentController = Get.find();
      final SubTaskDocumentController subTaskDocumentController = Get.find();

      // check status
      if (response.statusCode == 200) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Task Document: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(TaskDocumentModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                Future.delayed(const Duration(seconds: 1), () {
                  homeController.submitData();
                  notificationCountController.submitData();
                  documentController.submitTaskData();
                  subTaskDocumentController.submitSubTaskData();
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
    String issuPlace,
    String dateFrom,
    String dateTo,
    String filter,
    String token,
    String publicKey,
  ) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": docTaskHeader},
        "Data": {
          "Type": "",
          "IssuePlace": issuPlace,
          "DateFrom": dateFrom,
          "DateTo": dateTo,
          "TaskFilter": filter,
        }
      };
      String convertRequestBody = json.encode(requestBody);
      log('Request: $convertRequestBody');

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
        log('SubTask Document: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(TaskDocumentModel.fromJson(data));
      } else if (response.statusCode == 401) {
        return Left(response.statusMessage);
      } else if (response.statusCode == 403) {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Service have problem!',
        );
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

  String formatDateTime({DateTime? dateTime}) {
    return DateFormat('dd/MM/yyyy').format(dateTime!);
  }
}
