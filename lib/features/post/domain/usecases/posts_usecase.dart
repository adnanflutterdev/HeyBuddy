import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class PostsUsecase extends StreamUsecase<List<Post>,NoParams> {
  final PostRepository repository;
  PostsUsecase(this.repository);

  @override
  ResultStream<List<Post>> call(NoParams noParams) {
    return repository.getAllPosts();
  }
}
