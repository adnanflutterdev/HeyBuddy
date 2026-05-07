import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/feed/domain/entity/comment_entity.dart';
import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class AddCommentUsecase {
  final FeedRepository repository;

  AddCommentUsecase(this.repository);

  Future<Result> call(String postId, CommentEntity comment) {
    return repository.addComment(postId, comment);
  }
}
