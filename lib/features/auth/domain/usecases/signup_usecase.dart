import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class SignupUsecase extends FutureUsecase<void, SignupParams> {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  @override
  ResultFuture<void> call(SignupParams params) {
    return repository.signup(params.name, params.email, params.password);
  }
}

class SignupParams {
  final String name;
  final String email;
  final String password;

  SignupParams(this.name, this.email, this.password);
}
