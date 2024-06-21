import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../services/encryptor/aes_encryption.dart';
import '../services/encryptor/rsa_encryption.dart';
import '../services/url.dart';
import '../widget/app_widget.dart';

class ViewPDFController extends GetxController {
  ViewPDFController({required this.fileId, required this.fileName});
  final String fileId;
  String fileName;
  File? file;

  @override
  void onInit() {
    super.onInit();
    // Fetch file bytes and update the file path
    fetchFileBytes().then((bytes) {
      _updateFilePath(bytes);
    });
  }

  // Public method to fetch file bytes
  Future<List<int>> fetchFileBytes() async {
    try {
      final apiUrl = Uri.parse(viewFileUrl);
      final key = AESEncryption().generateBase64Key();
      var token = getStorage.read('token');
      var publicKey = getStorage.read('publicKey');

      // Request body
      final requestBody = {
        "Data": {
          "FileId": fileId,
        }
      };
      String convertRequestBody = json.encode(requestBody);
      log('View PDF: $convertRequestBody');

      // Encrypt AES
      final encryptAES = AESEncryption().encryptAES64(
        plainText: convertRequestBody,
        secretKeyBase64Text: key,
      );
      log('AES Key: $key');

      // Encrypt RSA
      final encryptRSA = await RSAEncryption().encryptRSA64(
        plainText: key,
        publicKeyStr: publicKey,
      );

      // Encode request body
      Map<String, dynamic> requestBodyEncrypt = {
        "q": encryptAES,
        "m": encryptRSA,
      };
      String convertRequestBodyEncrypt = json.encode(requestBodyEncrypt);
      log('View PDF Encrypt: $convertRequestBodyEncrypt');

      // Request response
      final response = await http.post(
        apiUrl,
        body: convertRequestBodyEncrypt,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      log('Response: ${response.statusCode}');

      // Check status
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception(
            'Error fetching file bytes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle the error here, you can display an error message
      AppWidget().errorScackbar(
        title: 'Error',
        message: 'Failed to fetch file. Please try again later.',
      );
      // Navigate back
      Get.back();
      return <int>[];
    }
  }

  // Update the file path and save it in the controller
  void _updateFilePath(List<int> bytes) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      file = File("${dir.path}/$fileName");
      await file!.writeAsBytes(bytes, flush: true);
      update();
      log('PDF downloaded successfully');
    } catch (e) {
      throw Exception('Error updating file path: $e');
    }
  }

  bool isValidFileExtension(String fileName) {
    List<String> allowedExtensions = [
      'pdf',
      'png',
      'jpg',
      'jpeg',
    ];

    String fileExtension = fileName.split('.').last.toLowerCase();
    return allowedExtensions.contains(fileExtension);
  }
}
