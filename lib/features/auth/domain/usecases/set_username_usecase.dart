import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_name.dart';

class SetUserNameUsecase extends FutureUsecase<void, SetUsernameParams> {
  final AuthRepository repository;

  SetUserNameUsecase(this.repository);

  @override
  ResultFuture<void> call(SetUsernameParams params) {
    return repository.setUsername(
      user: params.user,
      searchQueries: params.searchQueries,
    );
  }
}

class SetUsernameParams {
  final Username user;
  final List<String> searchQueries;

  SetUsernameParams(this.user, this.searchQueries);
}
