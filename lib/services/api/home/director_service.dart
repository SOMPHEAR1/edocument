import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';

import '../../../models/director_model.dart';
import '../../encryptor/aes_encryption.dart';
import '../../encryptor/rsa_encryption.dart';
import '../../url.dart';

class DirectorService {
  Future<dynamic> postAPI(String unitID, String token, String publicKey) async {
    try {
      var dio = Dio();
      final key = AESEncryption().generateBase64Key();

      // request body
      final requestBody = {
        "Header": {"MsgId": directorHeader},
        "Data": {"unitID": unitID}
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

      // check status
      if (response.statusCode == 200) {
        final decrypt =
            AESEncryption().decryptAES64('${response.data['q']}', key);
        // decode decrypt
        Map<String, dynamic> data = json.decode(decrypt);
        

        return Right(DirectorModel.fromJson(data));
      } else if (response.statusCode == 401) {
        return Left(response.statusMessage);
      } else if (response.statusCode == 403) {
      } else {
        return Left(response.statusMessage);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
