import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/domain/usecases/update_user_data_usecase.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

class UpdateUserDataNotifier extends StateNotifier<AsyncValue> {
  final UpdateUserDataUsecase updateUserDataUsecase;
  UpdateUserDataNotifier(this.updateUserDataUsecase)
    : super(const AsyncData(null));

  Future<Result> updateUserData(Details details, Profile profile) async {
    state = const AsyncLoading();

    try {
      Result result = await updateUserDataUsecase(details, profile);
      state = const AsyncData(null);
      return result;
    } catch (e) {
      state = const AsyncData(null);
      return Result(success: false, message: e.toString());
    }
  }
}

final updateUserDataProvider = StateNotifierProvider((ref) {
  final updateUserDataUsecase = ref.read(updateUserDataUsecaseProvider);

  return UpdateUserDataNotifier(updateUserDataUsecase);
});
