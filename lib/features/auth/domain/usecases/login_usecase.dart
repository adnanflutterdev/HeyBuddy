import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase extends FutureUsecase<void,LoginParams> {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  @override
  ResultFuture<void> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams{
  final String email;
  final String password;
  LoginParams(this.email,this.password);
}
