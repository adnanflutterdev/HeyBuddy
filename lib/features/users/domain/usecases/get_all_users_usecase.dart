import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/domain/repository/users_repository.dart';

class GetAllUsersUsecase extends StreamUsecase<List<UserData>, NoParams> {
  final UsersRepository repository;

  GetAllUsersUsecase(this.repository);

  @override
  ResultStream<List<UserData>> call(NoParams params) {
    return repository.getAllUsers();
  }
}
