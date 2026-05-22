import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class TogglePostLikeUsecase extends FutureUsecase<void, TogglePostLikeParams> {
  final PostRepository repository;

  TogglePostLikeUsecase(this.repository);
  @override
  ResultFuture call(TogglePostLikeParams params) async {
    return await repository.togglePostLike(
      id: params.id,
      uid: params.uid,
      isLiked: params.isLiked,
    );
  }
}

class TogglePostLikeParams {
  final String id;
  final String uid;
  final bool isLiked;

  TogglePostLikeParams(this.id, this.uid, this.isLiked);
}
