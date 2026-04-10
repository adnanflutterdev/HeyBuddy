import 'package:hey_buddy/core/model/result.dart';

abstract class AuthRepository {
  Future<Result> login(String email, String password);
  Future<Result> signup(String name, String email, String password);
  Future<void> logout();
}
