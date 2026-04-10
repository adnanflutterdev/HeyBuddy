import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUserData();
  Future<Result> updateUserData(DetailsEntity details, ProfileEnity profile);
}
