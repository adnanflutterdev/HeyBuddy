import 'package:hey_buddy/features/feed/domain/repository/feed_repository.dart';

class AllPostIdsUsecase {
  final FeedRepository repository;
  AllPostIdsUsecase(this.repository);

  Stream<List<String>> call() {
    return repository.getAllPostIds();
  }
}
