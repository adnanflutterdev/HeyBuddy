import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/comment.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/post/data/data_sources/post_remote_data_source.dart';
import 'package:hey_buddy/features/post/data/models/post_model.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class PostRepositoryImpl extends PostRepository {
  final PostRemoteDataSource remote;
  PostRepositoryImpl(this.remote);
  @override
  ResultFuture uploadPost(Post post) async {
    try {
      await remote.uploadFeedItem(PostModel.fromEntity(post));
      return Result.success(message: 'Post created successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to create post');
    } catch (e) {
      return Result.failure('Failed to create post');
    }
  }

  @override
  ResultStream<List<Post>> getAllPosts() {
    try {
      return remote.getAllPosts();
    } catch (_) {
      return Stream.value([]);
    }
  }

  @override
  Future<Post?> getPostData(String id) async {
    try {
      return await remote.getPostData(id);
    } catch (_) {
      return null;
    }
  }

  @override
  ResultStream<List<String>> getLikeStream(String id) {
    return remote.getLikeStream(id);
  }

  @override
  ResultFuture togglePostLike({
    required String id,
    required String uid,
    required bool isLiked,
  }) async {
    try {
      await remote.togglePostLike(id: id, uid: uid, isLiked: isLiked);
    } catch (e) {
      return Result.failure('Liked Successfully');
    }
    return Result.success(message: 'Liked Successfully');
  }

  @override
  ResultFuture addComment(String postId, Comment comment) async {
    try {
      await remote.addComment(postId, comment);
      return Result.success(message: 'Comment added!!!');
    } catch (e) {
      return Result.failure('Failed to add comment');
    }
  }

  @override
  ResultStream<List<Comment>> getComments(String postId) {
    return remote.getComments(postId);
  }
}
