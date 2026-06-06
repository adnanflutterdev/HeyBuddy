import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/clip/domain/repository/clip_repository.dart';

class ToggleClipLikeUsecase extends FutureUsecase<void, ToggleClipLikeParams> {
  final ClipRepository repository;

  ToggleClipLikeUsecase(this.repository);
  @override
  ResultFuture call(ToggleClipLikeParams params) async {
    return await repository.toggleClipLike(
      id: params.id,
      uid: params.uid,
      isLiked: params.isLiked,
    );
  }
}

class ToggleClipLikeParams {
  final String id;
  final String uid;
  final bool isLiked;

  ToggleClipLikeParams(this.id, this.uid, this.isLiked);
}
