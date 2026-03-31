import 'package:hey_buddy/features/profile/data/repository/user_repository_impl.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UserDataUsecase {
  final UserRepositoryImpl repository;

  UserDataUsecase(this.repository);

  Future<UserEntity> call() {
    return repository.getUserData();
  }
}
