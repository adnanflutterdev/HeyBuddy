import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class TogglePostLikeUsecase {
  final FeedRepository repository;

  TogglePostLikeUsecase(this.repository);

  Future<void> call({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    return await repository.togglePostLike(id: id, uid: uid, isLiked: isLiked);
  }
}
