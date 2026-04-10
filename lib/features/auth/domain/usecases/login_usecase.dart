import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Result> call(String email, String password) {
    return repository.login(email, password);
  }
}
