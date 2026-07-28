import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/usecases/update_online_status_usecase.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

class OnlineStatusNotifier extends StateNotifier<AsyncValue> {
  final UpdateOnlineStatusUsecase updateOnlineStatusUsecase;
  OnlineStatusNotifier(this.updateOnlineStatusUsecase)
    : super(const AsyncData(null));

  ResultFuture<void> updateActiveStatus(
    UpdateOnlineStatusUsecaseParams params,
  ) async {
    state = const AsyncLoading();
    final result = await updateOnlineStatusUsecase(params);
    state = const AsyncData(null);
    return result;
  }
}

final onlineStatusProvider = StateNotifierProvider((ref) {
  final updateOnlineStatusUsecase = ref.read(updateOnlineStatusUsecaseProvider);
  return OnlineStatusNotifier(updateOnlineStatusUsecase);
});
