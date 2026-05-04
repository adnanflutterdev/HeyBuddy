import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';

abstract class FeedRepository {
  Future<Result> uploadFeedItem(FeedItemEntity feedItem);
  Stream<List<FeedItemEntity>> getAllPosts();
  Future<FeedItemEntity?> getPostData(String id);
  Stream<List<String>> getLikeStream(String id);
  Future<void> togglePostLike({
    required String id,
    required String uid,
    required bool isLiked,
  });
}
