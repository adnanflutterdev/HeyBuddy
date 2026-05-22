import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Security {
  final String token;
  final List<LoginHistory> loginHistory;
  
  Security({required this.token, required this.loginHistory});
}

abstract class LoginHistory {
  final String device;
  final String ip;
  final Timestamp loginTime;

  LoginHistory({
    required this.device,
    required this.ip,
    required this.loginTime,
  });
}
