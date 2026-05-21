import 'package:hey_buddy/core/model/comment.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class AddCommentUsecase {
  final PostRepository repository;

  AddCommentUsecase(this.repository);

  Future<Result> call(String postId, Comment comment) {
    return repository.addComment(postId, comment);
  }
}
