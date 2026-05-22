import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';

abstract class PostRepository {
  ResultFuture<void> uploadPost(Post post);
  ResultStream<List<Post>> getAllPosts();
  ResultFuture<Post> getPostData(String id);
  ResultStream<List<String>> getLikeStream(String id);
  ResultFuture<void> togglePostLike({
    required String id,
    required String uid,
    required bool isLiked,
  });
  
}
