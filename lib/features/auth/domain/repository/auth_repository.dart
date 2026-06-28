import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_name.dart';

abstract class AuthRepository {
  ResultFuture<void> logout();
  ResultFuture<void> googleSignin();
  ResultFuture<void> login(String email, String password);
  ResultFuture<void> signup(String name, String email, String password);
  ResultFuture<bool> doesUserExists(String username);
  ResultFuture<void> setUsername({
    required Username user,
    required List<String> searchQueries,
  });
}
