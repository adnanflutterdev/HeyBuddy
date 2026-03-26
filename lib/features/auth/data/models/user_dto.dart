import 'package:hey_buddy/features/auth/domain/entity/user_entity.dart';

class UserDto extends UserEntity {
  UserDto({required super.uid, required super.name, required super.email});

  factory UserDto.fromFirebase(Map<String, dynamic> user) {
    return UserDto(uid: user['uid'], name: user['name'], email: user['email']);
  }

  Map<String, dynamic> toFirebase() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
