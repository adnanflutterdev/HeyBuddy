import 'package:firebase_auth/firebase_auth.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';
import 'package:hey_buddy/features/auth/data/data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Result> login(String email, String password) async {
    try {
      final response = await remote.login(email, password);
      if (response.user == null) {
        return Result.failure('User is null');
      } else {
        return Result.success('Login success');
      }
    } on FirebaseAuthException catch (e) {
      return Result.failure(e.message ?? 'Falied to login');
    } catch (e) {
      return Result.failure('Something went wrong');
    }
  }

  @override
  Future<Result> signup(String name, String email, String password) async {
    try {
      final response = await remote.signup(name, email, password);
      if (response.user == null) {
        return Result.failure('User is null');
      } else {
        await remote.saveUser(response.user!.uid, name, email);
        return Result.success('Signup success');
      }
    } on FirebaseAuthException catch (e) {
      return Result.failure(e.message ?? 'Falied to create account');
    } catch (e) {
      return Result.failure('Something went wrong');
    }
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }
}
