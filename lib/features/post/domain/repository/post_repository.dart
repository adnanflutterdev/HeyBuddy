import 'package:hey_buddy/core/model/comment.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';

abstract class PostRepository {
  ResultFuture uploadPost(Post post);
  ResultStream<List<Post>> getAllPosts();
  Future<Post?> getPostData(String id);
  ResultStream<List<String>> getLikeStream(String id);
  ResultFuture togglePostLike({
    required String id,
    required String uid,
    required bool isLiked,
  });
  ResultStream<List<Comment>> getComments(String postId);
  ResultFuture addComment(String postId, Comment comment);
}
