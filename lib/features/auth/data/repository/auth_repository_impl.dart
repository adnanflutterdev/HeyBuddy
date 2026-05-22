import 'package:firebase_auth/firebase_auth.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';
import 'package:hey_buddy/features/auth/data/data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  ResultFuture<void> login(String email, String password) async {
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
  ResultFuture<void> signup(String name, String email, String password) async {
    UserCredential? response;
    try {
      response = await remote.signup(name, email, password);
      if (response.user == null) {
        return Result.failure('User is null');
      } else {
        await remote.saveUser(response.user!.uid, name, email);
        return Result.success('Signup success');
      }
    } on FirebaseAuthException catch (e) {
      if (response != null) {
        await response.user?.delete();
      }
      return Result.failure(e.message ?? 'Failed to signup');
    } catch (e) {
      if (response != null) {
        await response.user?.delete();
      }
      return Result.failure('Something went wrong');
    }
  }

  @override
  ResultFuture<void> logout() async {
    try {
      await remote.logout();
      return Future.value(Result.success('You logged out!!!'));
    } catch (e) {
      return Future.value(Result.failure('Failed to logout!!!'));
    }
  }
}
