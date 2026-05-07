import 'package:hey_buddy/features/feed/domain/entity/comment_entity.dart';
import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class GetCommentUsecase {
  final FeedRepository repository;

  GetCommentUsecase(this.repository);

  Stream<List<CommentEntity>> call(String postId) {
    return repository.getComments(postId);
  }
}
