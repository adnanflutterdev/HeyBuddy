import 'package:encrypt/encrypt.dart' as en;

class Encryption {
  // Encryption
  static String encrypt({
    required String encryptionKey,
    required String encryptionValue,
    required String message,
  }) {
    final key = en.Key.fromUtf8(encryptionKey);
    final iv = en.IV.fromUtf8(encryptionValue);
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
    final key = en.Key.fromUtf8(encryptionKey);
    final iv = en.IV.fromUtf8(encryptionValue);
    final encrypter = en.Encrypter(
      en.AES(key, mode: en.AESMode.cbc, padding: 'PKCS7'),
    );
    final decrypted = encrypter.decrypt64(message, iv: iv);
    return decrypted;
  }
}
