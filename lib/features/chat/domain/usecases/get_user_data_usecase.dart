import 'package:hey_buddy/features/chat/domain/repository/users_repository.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class GetUserDataUsecase {
  final UsersRepository repository;

  GetUserDataUsecase(this.repository);

  Future<UserEntity> call(String id) async {
    return await repository.getUserData(id);
  }
}
