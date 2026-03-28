import 'package:hey_buddy/features/auth/domain/entity/auth_response_entity.dart';

abstract class AuthRepository {
  Future<AuthResponseEntity> login(String email, String password);
  Future<AuthResponseEntity> signup(String name, String email, String password);
  Future<void> logout();
}
