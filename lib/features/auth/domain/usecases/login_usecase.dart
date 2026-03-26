import 'package:hey_buddy/features/auth/domain/entity/auth_response.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<AuthResponseEntity> call(String email, String password) {
    return repository.login(email, password);
  }
}
