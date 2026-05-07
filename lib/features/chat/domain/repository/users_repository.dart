import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class UsersRepository {
  Future<UserEntity> getUserData(String id);
}
