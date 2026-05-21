import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class PostsUsecase {
  final PostRepository repository;
  PostsUsecase(this.repository);

  Stream<List<Post>> call() {
    return repository.getAllPosts();
  }
}
