import 'package:hey_buddy/features/profile/domain/entity/user_name.dart';

class UsernameModel extends Username {
  UsernameModel({
    required super.uid,
    required super.email,
    required super.username,
  });

  factory UsernameModel.fromEntity(Username user) {
    return UsernameModel(
      uid: user.uid,
      email: user.email,
      username: user.username,
    );
  }

  factory UsernameModel.fromFirebase(Map<String, dynamic> user) {
    return UsernameModel(
      uid: user['uid'],
      email: user['email'],
      username: user['username'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {"uid": uid, "email": email, "username": username};
  }
}
