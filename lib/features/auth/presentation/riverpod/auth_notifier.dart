import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/auth/domain/entity/auth_response_entity.dart';
import 'package:hey_buddy/features/auth/domain/usecases/login_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/logout_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/signup_usecase.dart';

class AuthNotifier extends StateNotifier<AsyncValue<AuthResponseEntity?>> {
  final LoginUsecase _loginUsecase;
  final SignupUsecase _signupUsecase;
  final LogoutUsecase _logoutUsecase;
  AuthNotifier(this._loginUsecase, this._signupUsecase, this._logoutUsecase)
    : super(const AsyncData(null));

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      final response = await _loginUsecase(email, password);
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncLoading();

    try {
      final response = await _signupUsecase(name, email, password);
      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      await _logoutUsecase();
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
