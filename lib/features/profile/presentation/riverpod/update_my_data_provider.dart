import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/data/models/user__data_model.dart';
import 'package:hey_buddy/features/profile/domain/usecases/update_my_data_usecase.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

class UpdateMyDataNotifier extends StateNotifier<AsyncValue> {
  final UpdateMyDataUsecase updateMyDataUsecase;
  UpdateMyDataNotifier(this.updateMyDataUsecase) : super(const AsyncData(null));

  Future<Result> updateMyData(
    DetailsModel details,
    ProfileModel profile,
  ) async {
    state = const AsyncLoading();

    try {
      Result result = await updateMyDataUsecase(details, profile);
      state = const AsyncData(null);
      return result;
    } catch (e) {
      state = const AsyncData(null);
      return Result.failure('Something went wrong');
    }
  }
}

final updateMyDataProvider = StateNotifierProvider((ref) {
  final updateMyDataUsecase = ref.read(updateMyDataUsecaseProvider);
  return UpdateMyDataNotifier(updateMyDataUsecase);
});
