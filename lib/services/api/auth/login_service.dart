// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:e_document_app/services/encryptor/aes_encryption.dart';
import 'package:e_document_app/services/encryptor/rsa_encryption.dart';
import 'package:either_dart/either.dart';

import '../../../models/login_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../widget/app_widget.dart';
import '../../url.dart';

String publicKey = '';
String newPublicKey = '';
String? fcmToken = '';

class LoginService {
  Future<dynamic> postAPI(
    final username,
    final password,
    final token,
  ) async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // Get device information
      AndroidDeviceInfo? androidInfo;
      IosDeviceInfo? iosInfo;

      if (Platform.isAndroid) {
        androidInfo = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isIOS) {
        iosInfo = await deviceInfoPlugin.iosInfo;
      }

      // request body
      Map<String, dynamic> requestBody = {
        'Header': {
          'Platform': Platform.isAndroid ? 'Android' : 'iOS',
          'DeviceModel': Platform.isAndroid
              ? androidInfo!.model
              : iosInfo!.utsname.machine,
          'DeviceId': Platform.isAndroid
              ? androidInfo!.id
              : iosInfo!.identifierForVendor,
          'ApplicationId': 'EDOC'
        },
        'Data': {
          'Username': username,
          'Password': password,
          'TokenNotify': token
        }
      };
      String convertRequestBody = json.encode(requestBody);

      // encrypt AES
      final encryptAES = AESEncryption().encryptAES64(
        plainText: convertRequestBody,
        secretKeyBase64Text: key,
      );

      // encrypt RSA
      String publicKey =
          'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoMGngEFhIUPs9ZgusEbFxragyq5Zbr+abAzWsTXpk7GkxzWT3A/vv/3a3OlupYaB36RtFcITt+pCKJwlcISWbxOT4XYhXtFFCCD9MKS7c0/2cnWHfzeZqDbq3frtYTFoIigFUk1rn73PO12dz4q8tIZ6a+EVSzNatmPdkB9mNTiy5ZF6Qjcyf85Aglhx8VgmmiGhUct53dsZr5Ze+nBuPra/xBEg+LwjLYlj2kmqreCjxkIFTGbp+50w0s7mLbwHZuFLdQnumZu8hFyiJv2XRtq/ndPeI8mwky5lxeveucKuZYlcKOk/ZOomu5QlzpP1UvfjvTDJdur5Pb9kJdeZ7QIDAQAB';

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
        loginUrl,
        data: convertRequestBodyEncrypt,
        options: Options(
          validateStatus: (_) => true,
        ),
      );

      // check status
      if (response.statusCode == 200 && response.data['q'] != null) {
        // decrypt response
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        log('Login: $decrypt');

        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);

        return Right(LoginModel.fromJson(data));
      } else if (response.statusCode == 403) {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: 'Service have problem!',
        );
        return Left(response.statusMessage);
      } else if (response.statusCode == 500) {
        AppWidget().errorScackbar(
          title: 'Invalid Home Screen',
          message: 'Internal Server Error!',
        );
        return Left(response.statusMessage);
      } else {
        AppWidget().errorScackbar(
          title: 'Invalid',
          message: '${response.data['ErrorDetail']}',
        );
        return Left(response.statusMessage);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
