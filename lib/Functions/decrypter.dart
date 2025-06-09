import 'package:encrypt/encrypt.dart' as encrypt;

String decrypter(String message) {
  final key = encrypt.Key.fromUtf8('____mohammad____adnan____ansari_');
  final iv = encrypt.IV.fromUtf8('mohammad___adnan');
  final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
  message = encrypter.decrypt64(message, iv: iv);
  return message;
}
