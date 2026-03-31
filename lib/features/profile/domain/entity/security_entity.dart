import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SecurityEntity {
  final String token;
  final List<LoginHistoryEntity> loginHistory;
  SecurityEntity({required this.token, required this.loginHistory});
}

abstract class LoginHistoryEntity {
  final String device;
  final String ip;
  final Timestamp loginTime;
  LoginHistoryEntity({
    required this.device,
    required this.ip,
    required this.loginTime,
  });
}
