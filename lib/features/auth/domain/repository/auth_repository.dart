import 'package:hey_buddy/core/typedefs/typedefs.dart';

abstract class AuthRepository {
  ResultFuture<void> login(String email, String password);
  ResultFuture<void> signup(String name, String email, String password);
  ResultFuture<void> logout();
}
