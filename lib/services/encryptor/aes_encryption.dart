
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';

class AESEncryption {
  final String iv = 'BIDCBANK_NUMBER1';

  generateBase64Key() {
    int len = 16; //16 byte
    var chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var r = Random();
    String strBase64Key =
        List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
    List<int> bytes = utf8.encode(strBase64Key);
    return base64.encode(bytes);
  }

  encryptAES64({String? plainText, String? secretKeyBase64Text}) {
    final key = Key.fromUtf8(
      String.fromCharCodes(base64.decode(secretKeyBase64Text!)),
    );
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));
    final initializationVector = IV.fromUtf8(iv);
    final encrypted = encrypter.encrypt(
      plainText!,
      iv: initializationVector,
    );
    return encrypted.base64;
  }

  decryptAES64(String encryptedBas64Text, String secretKeyBase64Text) {
    final key = Key.fromUtf8(
      String.fromCharCodes(base64.decode(secretKeyBase64Text)),
    );
    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));
    final initializationVector = IV.fromUtf8(iv);
    final decrypted = encrypter.decrypt64(
      encryptedBas64Text,
      iv: initializationVector,
    );
    return decrypted;
  }
}
