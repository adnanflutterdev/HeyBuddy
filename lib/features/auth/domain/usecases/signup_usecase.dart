import 'package:hey_buddy/features/auth/domain/entity/auth_response.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<AuthResponseEntity> call(String name, String email, String password) {
    return repository.signup(name, email, password);
  }
}
