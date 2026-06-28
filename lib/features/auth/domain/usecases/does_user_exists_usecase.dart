import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class DoesUserExistsUsecase extends FutureUsecase<bool, DoesUserExistsParam> {
  final AuthRepository repository;

  DoesUserExistsUsecase(this.repository);

  @override
  ResultFuture<bool> call(DoesUserExistsParam params) {
    return repository.doesUserExists(params.username);
  }
}

class DoesUserExistsParam {
  final String username;

  DoesUserExistsParam(this.username);
}
