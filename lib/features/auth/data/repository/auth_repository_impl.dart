import 'package:firebase_auth/firebase_auth.dart';
import 'package:hey_buddy/features/auth/data/models/user_dto.dart';
import 'package:hey_buddy/features/auth/domain/entity/auth_response.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';
import 'package:hey_buddy/features/auth/data/data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthResponseEntity> login(String email, String password) async {
    try {
      final response = await remote.login(email, password);
      if (response.user == null) {
        return AuthResponseEntity.failure('User is null');
      } else {
        return AuthResponseEntity.success('Login success');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResponseEntity.failure(e.message ?? 'Falied to login');
    } catch (e) {
      return AuthResponseEntity.failure('Something went wrong');
    }
  }

  @override
  Future<AuthResponseEntity> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await remote.signup(name, email, password);
      if (response.user == null) {
        return AuthResponseEntity.failure('User is null');
      } else {
        final String uid = response.user!.uid;
        UserDto userDto = UserDto(uid: uid, name: name, email: email);
        await remote.saveUser(userDto);
        return AuthResponseEntity.success('Signup success');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResponseEntity.failure(
        e.message ?? 'Falied to create account',
      );
    } catch (e) {
      return AuthResponseEntity.failure('Something went wrong');
    }
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }
}
