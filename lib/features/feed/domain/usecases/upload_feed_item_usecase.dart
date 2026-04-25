import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class UploadFeedItemUsecase {
  final FeedRepository repository;

  UploadFeedItemUsecase(this.repository);

  Future<Result> call(FeedItemEntity feedItem) {
    return repository.uploadFeedItem(feedItem);
  }
}
