
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_document_app/controllers/proposal_detail_controller.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../controllers/assign_doc_controller.dart';
import '../../../controllers/bom_controller.dart';
import '../../../controllers/comment_controller.dart';
import '../../../controllers/login_controller.dart';
import '../../../controllers/director_controller.dart';
import '../../../models/proposal_detail_model.dart';
import '../../../models/task_proposal_model.dart';
import '../../../widget/app_widget.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class ProposalDetailService {
  Future<dynamic> postCommentAPI(
      String documentID, String token, String publicKey) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": proposalDetailHeader},
        "Data": {"DocumentId": documentID}
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

      final LoginController loginController = Get.put(LoginController());
      final CommentController commentController = Get.find();
      final BOMController bomController = Get.find();
      final DirectorController directorController = Get.find();

      log('response : ${response.statusCode}');

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Comment: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(ProposalDetailModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                Future.delayed(const Duration(seconds: 1), () {
                  commentController.submitData();
                  bomController.submitData();
                  directorController.submitData();
                  Get.put(AssignDocController());
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

  Future<dynamic> postDetailAPI(
      String documentID, String token, String publicKey) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": taskProposalHeader},
        "Data": {"DocumentId": documentID}
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

      final LoginController loginController = Get.put(LoginController());
      final ProposalDetailController documentDetailController = Get.find();

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Proposal Document Detail: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(ProposalDetailModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            loginController.expiredLogin(
              action: () {
                EasyLoading.show(status: 'loading...');
                
                Future.delayed(const Duration(seconds: 1), () {
                  documentDetailController.submitData();
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

  Future<dynamic> postTaskProposalAPI(
      String documentID, String token, String publicKey) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": taskProposalHeader},
        "Data": {"DocumentId": documentID}
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

      final LoginController loginController = Get.put(LoginController());
      final CommentController commentController = Get.find();

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Task Proposal: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(TaskProposalModel.fromJson(data));
      } else if (response.statusCode == 401) {
        AppWidget().loginPopup(
          refreshAction: () async {
            EasyLoading.show(status: 'loading...');
            loginController.expiredLogin(
              action: () {
                commentController.submitTaskProsal();
                EasyLoading.showSuccess(
                  'Login Success',
                  duration: const Duration(seconds: 1),
                );
                EasyLoading.dismiss();
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
}
