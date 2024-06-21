// ignore_for_file: unused_local_variable

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAEncryption {
  Future<T> parseKeyFromStr<T extends RSAAsymmetricKey>(String str) async {
    final paser = RSAKeyParser();
    return paser.parse(str) as T;
  }

  encryptRSA64({required String plainText, String? publicKeyStr}) async {
    String publicKeyPEM =
        '-----BEGIN PUBLIC KEY-----\n$publicKeyStr\n-----END PUBLIC KEY-----';
    final publicKey = await parseKeyFromStr<RSAPublicKey>(publicKeyPEM);
    Encrypter encrypter;
    Encrypted encrypted;
    encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.PKCS1,
        digest: RSADigest.SHA256,
      ),
    );

    encrypted = encrypter.encrypt(plainText);
    return encrypted.base64.toString();
  }

  decryptRSA64({String? publicKeyStr, String? privateKeyStr}) async {
    String publicKeyPEM =
        '-----BEGIN PUBLIC KEY-----\n$publicKeyStr\n-----END PUBLIC KEY-----';
    String privateKeyPEM =
        '-----BEGIN PRIVATE KEY-----\n$privateKeyStr\n-----END PRIVATE KEY-----';
    final publicKey = await parseKeyFromFile<RSAPublicKey>('test/public.pem');
    final privKey = await parseKeyFromFile<RSAPrivateKey>('test/private.pem');

    final encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        privateKey: privKey,
        encoding: RSAEncoding.PKCS1,
        digest: RSADigest.SHA256,
      ),
    );

    final decrypted = encrypter.decrypt64('');
  }
}
