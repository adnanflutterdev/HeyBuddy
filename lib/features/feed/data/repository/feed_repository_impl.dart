import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/feed/data/data_sources/feed_remote_data_source.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class FeedRepositoryImpl extends FeedRepository {
  final FeedRemoteDataSource remote;
  FeedRepositoryImpl(this.remote);
  @override
  Future<Result> uploadFeedItem(FeedItemEntity feedItem) async {
    try {
      await remote.uploadFeedItem(feedItem);
      return Result.success('Post created successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to create post');
    } catch (e) {
      return Result.failure('Failed to create post');
    }
  }

  @override
  Future<List<String>> getAllPostIds() async {
    try {
      return await remote.getAllPostIds();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<FeedItemEntity?> getPostData(String id) async {
    try {
      return await remote.getPostData(id);
    } catch (_) {
      return null;
    }
  }
}
