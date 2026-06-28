import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/auth/domain/usecases/does_user_exists_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/set_username_usecase.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/providers.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_name.dart';

class UserNameNotifier extends StateNotifier<AsyncValue> {
  final DoesUserExistsUsecase doesUserExistsUsecase;
  final SetUserNameUsecase setUserNameUsecase;
  UserNameNotifier(this.doesUserExistsUsecase, this.setUserNameUsecase)
    : super(const AsyncData(null));

  ResultFuture<bool> doesUserExists(String username) async {
    state = const AsyncLoading();
    final result = await doesUserExistsUsecase(DoesUserExistsParam(username));
    state = const AsyncData(null);
    return result;
  }

  ResultFuture<void> setUserName(
    Username user,
    List<String> searchQueries,
  ) async {
    state = const AsyncLoading();
    final result = await setUserNameUsecase(
      SetUsernameParams(user, searchQueries),
    );
    state = const AsyncData(null);
    return result;
  }
}

final usernameProvider = StateNotifierProvider<UserNameNotifier, AsyncValue>((
  ref,
) {
  final doesUserExistsUsecase = ref.read(doesUserExistsUsecaseProvider);
  final setUserNameUsecase = ref.read(setUserNameUsecaseProvider);

  return UserNameNotifier(doesUserExistsUsecase, setUserNameUsecase);
});
