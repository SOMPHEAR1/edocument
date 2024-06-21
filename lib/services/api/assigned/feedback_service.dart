import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../../../models/feedback_model.dart';
import '../../../widget/app_widget.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class FeedbackService {
  Future<dynamic> postAPI(
    String assignmentId,
    String token,
    String publicKey,
  ) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": feedbackListHeader},
        "Data": {"AssignmentId": assignmentId}
      };
      String convertRequestBody = json.encode(requestBody);
      log('feedback request: $convertRequestBody');

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
        log('Feedback List: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(FeedbackModel.fromJson(data));
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
}
