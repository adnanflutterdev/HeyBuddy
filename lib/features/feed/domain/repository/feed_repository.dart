import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';

abstract class FeedRepository {
  Future<Result> uploadFeedItem(FeedItemEntity feedItem);
  Stream<List<String>> getAllPostIds();
  Future<FeedItemEntity?> getPostData(String id);
}
