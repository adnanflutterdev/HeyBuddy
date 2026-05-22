import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/login_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/logout_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/signup_usecase.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/providers.dart';

class AuthNotifier extends StateNotifier<AsyncValue<Result?>> {
  final LoginUsecase _loginUsecase;
  final SignupUsecase _signupUsecase;
  final LogoutUsecase _logoutUsecase;

  AuthNotifier(this._loginUsecase, this._signupUsecase, this._logoutUsecase)
    : super(const AsyncData(null));

  ResultFuture<void> login(String email, String password) async {
    state = const AsyncLoading();
    LoginParams params = LoginParams(email, password);
    final result = await _loginUsecase(params);
    state = const AsyncData(null);
    return result;
  }

  ResultFuture<void> signup(String name, String email, String password) async {
    state = const AsyncLoading();
    SignupParams params = SignupParams(name, email, password);
    final result = await _signupUsecase(params);
    state = const AsyncData(null);
    return result;
  }

  ResultFuture<void> logout() async {
    state = const AsyncLoading();
    final result = await _logoutUsecase(NoParams());
    state = const AsyncData(null);
    return result;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<Result?>>(
  (ref) => AuthNotifier(
    ref.read(loginProvider),
    ref.read(signupProvider),
    ref.read(logoutProvider),
  ),
);
