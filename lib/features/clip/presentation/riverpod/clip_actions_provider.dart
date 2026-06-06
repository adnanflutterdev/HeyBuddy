import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/features/clip/domain/usecases/toggle_clip_like_usecase.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/providers.dart';

class ClipActionsNotifier extends StateNotifier<AsyncValue> {
  final ToggleClipLikeUsecase toggleClipLikeUsecase;
  ClipActionsNotifier(this.toggleClipLikeUsecase)
    : super(const AsyncData(null));

  Future<void> toggleClipLike({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    state = const AsyncLoading();
    await toggleClipLikeUsecase(ToggleClipLikeParams(id, uid, isLiked));
    state = const AsyncData(null);
  }
}

final clipActionProvider =
    StateNotifierProvider<ClipActionsNotifier, AsyncValue>((ref) {
      final toggleClipLikeUsecase = ref.read(toggleClipLikeUsecaseProvider);
      return ClipActionsNotifier(toggleClipLikeUsecase);
    });
