import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class AllPostIdsUsecase {
  final FeedRepository repository;
  AllPostIdsUsecase(this.repository);

  Future<List<String>> call() {
    return repository.getAllPostIds();
  }
}
