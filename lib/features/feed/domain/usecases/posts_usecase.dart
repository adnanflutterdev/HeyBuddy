import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class PostsUsecase {
  final FeedRepository repository;
  PostsUsecase(this.repository);

  Stream<List<FeedItemEntity>> call() {
    return repository.getAllPosts();
  }
}
