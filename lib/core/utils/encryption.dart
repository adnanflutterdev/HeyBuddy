import 'package:encrypt/encrypt.dart' as en;
import 'package:uuid/uuid.dart';

class Encryption {
  // Encryption
  static String encrypt({
    required String encryptionKey,
    required String encryptionValue,
    required String message,
  }) {
    const Uuid().v4();
    final key = en.Key.fromUtf8(encryptionKey.substring(0, 32));
    final iv = en.IV.fromUtf8(encryptionValue.substring(0, 16));
    final encrypter = en.Encrypter(en.AES(key, mode: en.AESMode.cbc));
    final encrypted = encrypter.encrypt(message, iv: iv);
    return encrypted.base64;
  }

  // Decryption
  static String decrypt({
    required String encryptionKey,
    required String encryptionValue,
    required String message,
  }) {
    final key = en.Key.fromUtf8(encryptionKey.substring(0, 32));
    final iv = en.IV.fromUtf8(encryptionValue.substring(0, 16));
    final encrypter = en.Encrypter(
      en.AES(key, mode: en.AESMode.cbc, padding: 'PKCS7'),
    );
    final decrypted = encrypter.decrypt64(message, iv: iv);
    return decrypted;
  }
}
