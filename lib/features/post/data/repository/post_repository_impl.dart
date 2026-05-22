import 'package:cloud_firestore/cloud_firestore.dart';
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
      await remote.uploadPost(PostModel.fromEntity(post));
      return Result.success('Post created successfully');
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
      return Stream.error('Failed to fetch posts');
    }
  }

  @override
  ResultFuture<Post> getPostData(String id) async {
    try {
      final post = await remote.getPostData(id);
      return Result.success('Post Data Fetched', data: post);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to fetch post');
    } catch (_) {
      return Result.failure('Failed to fetch post');
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
      return Result.success('Liked toggled Successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to toggle like');
    } catch (e) {
      return Result.failure('Failed liked to toggle like');
    }
  }
}
