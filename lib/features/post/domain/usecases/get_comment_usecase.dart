import 'package:hey_buddy/core/model/comment.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class GetCommentUsecase {
  final PostRepository repository;

  GetCommentUsecase(this.repository);

  Stream<List<Comment>> call(String postId) {
    return repository.getComments(postId);
  }
}
