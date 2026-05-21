import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class GetPostDataUsecase {
  final PostRepository repository;

  GetPostDataUsecase(this.repository);

  Future<Post?> call(String id) async {
    return await repository.getPostData(id);
  }
}
