import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/features/feed/domain/usecases/toggle_post_like_usecase.dart';
import 'package:hey_buddy/features/feed/riverpod/providers.dart';

class PostActionsNotifier extends StateNotifier<AsyncValue> {
  final TogglePostLikeUsecase togglePostLikeUsecase;
  PostActionsNotifier(this.togglePostLikeUsecase)
    : super(const AsyncData(null));

  Future<void> togglePostLike({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    state = const AsyncLoading();
    await togglePostLikeUsecase(id: id, uid: uid, isLiked: isLiked);
    state = const AsyncData(null);
  }
}

final postActionProvider =
    StateNotifierProvider<PostActionsNotifier, AsyncValue>((ref) {
      final togglePostLikeUsecase = ref.read(togglePostLikeUsecaseProvider);
      return PostActionsNotifier(togglePostLikeUsecase);
    });
