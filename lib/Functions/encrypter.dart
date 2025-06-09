import 'package:encrypt/encrypt.dart' as encrypt;

String encrypter(String message) {
  final key = encrypt.Key.fromUtf8('____mohammad____adnan____ansari_');
  final iv = encrypt.IV.fromUtf8('mohammad___adnan');
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(message, iv: iv);
  message = encrypted.base64;
  return message;
}
