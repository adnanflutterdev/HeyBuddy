import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/post/domain/entity/reaction.dart';

abstract class CommentRepository {
  ResultStream<List<Comment>> getComments(String postId);
  ResultFuture<void> addComment(String postId, Comment comment);
  ResultFuture<void> addReaction({
    required String id,
    required String commentId,
    required Reaction reaction,
  });
}
