import 'package:hey_buddy/features/profile/domain/entity/security.dart';

class SecurityModel extends Security {
  SecurityModel({required super.token, required super.loginHistory});

  factory SecurityModel.setNewUser() {
    return SecurityModel(
      token: '__THIS FEATURE IS NOT IMPLEMENTED YET__',
      loginHistory: [LoginHistoryModel.setNewUser()],
    );
  }
  factory SecurityModel.fromFirebase(Map<String, dynamic> security) {
    return SecurityModel(
      token: security['token'],
      loginHistory: (security['loginHistory'] as List<dynamic>? ?? [])
          .map(
            (loginHistory) => LoginHistoryModel.fromFirebase(
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
          .map((login) => (login as LoginHistoryModel).toFirebase())
          .toList(),
    };
  }
}

class LoginHistoryModel extends LoginHistory {
  LoginHistoryModel({
    required super.device,
    required super.ip,
    required super.loginTime,
  });

  factory LoginHistoryModel.setNewUser() {
    return LoginHistoryModel(
      device: '__THIS FEATURE IS NOT IMPLEMENTED YET__',
      ip: '__THIS FEATURE IS NOT IMPLEMENTED YET__',
      loginTime: .now(),
    );
  }

  factory LoginHistoryModel.fromFirebase(Map<String, dynamic> loginHistory) {
    return LoginHistoryModel(
      device: loginHistory['device'],
      ip: loginHistory['ip'],
      loginTime: loginHistory['loginTime'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {"device": device, "ip": ip, "loginTime": loginTime};
  }
}
