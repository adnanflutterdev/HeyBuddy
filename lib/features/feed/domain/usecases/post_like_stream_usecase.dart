import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class PostLikeStreamUsecase {
  final FeedRepository repository;

  PostLikeStreamUsecase(this.repository);

  Stream<List<String>> call(String id) {
    return repository.getLikeStream(id);
  }
}
