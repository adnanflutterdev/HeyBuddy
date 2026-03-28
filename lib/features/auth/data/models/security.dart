import 'package:hey_buddy/features/auth/domain/entity/security_entity.dart';

class Security extends SecurityEntity {
  Security({required super.token, required super.loginHistory});

  factory Security.setNewUser() {
    return Security(
      token: '__THIS FEATURE IS NOT IMPLEMENTED YET__',
      loginHistory: [LoginHistory.setNewUser()],
    );
  }
  factory Security.fromFirebase(Map<String, dynamic> security) {
    return Security(
      token: security['token'],
      loginHistory: (security['loginHistory'] as List<dynamic>? ?? [])
          .map(
            (loginHistory) => LoginHistory.fromFirebase(
              Map<String, dynamic>.from(loginHistory),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "token": token,
      "loginHistory": (loginHistory)
          .map((login) => (login as LoginHistory).toFirebase())
          .toList(),
    };
  }
}

class LoginHistory extends LoginHistoryEntity {
  LoginHistory({
    required super.device,
    required super.ip,
    required super.loginTime,
  });

  factory LoginHistory.setNewUser() {
    return LoginHistory(
      device: '__THIS FEATURE IS NOT IMPLEMENTED YET__',
      ip: '__THIS FEATURE IS NOT IMPLEMENTED YET__',
      loginTime: .now(),
    );
  }

  factory LoginHistory.fromFirebase(Map<String, dynamic> loginHistory) {
    return LoginHistory(
      device: loginHistory['device'],
      ip: loginHistory['ip'],
      loginTime: loginHistory['loginTime'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {"device": device, "ip": ip, "loginTime": loginTime};
  }
}
