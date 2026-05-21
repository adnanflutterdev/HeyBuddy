import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class TogglePostLikeUsecase {
  final PostRepository repository;

  TogglePostLikeUsecase(this.repository);

  ResultFuture call({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    return await repository.togglePostLike(id: id, uid: uid, isLiked: isLiked);
  }
}
