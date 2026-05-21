import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class PostLikeStreamUsecase {
  final PostRepository repository;

  PostLikeStreamUsecase(this.repository);

  Stream<List<String>> call(String id) {
    return repository.getLikeStream(id);
  }
}
