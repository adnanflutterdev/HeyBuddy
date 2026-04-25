import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class GetPostDataUsecase {
  final FeedRepository repository;

  GetPostDataUsecase(this.repository);

  Future<FeedItemEntity?> call(String id) async {
    return await repository.getPostData(id);
  }
}
