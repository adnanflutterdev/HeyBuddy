import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/domain/repository/users_repository.dart';

class GetAllUsersUsecase extends FutureUsecase<List<UserData>, QueryParam> {
  final UsersRepository repository;

  GetAllUsersUsecase(this.repository);

  @override
  ResultFuture<List<UserData>> call(QueryParam params) {
    return repository.searchUsers(params.query);
  }
}

class QueryParam {
  final String query;

  QueryParam(this.query);
}
