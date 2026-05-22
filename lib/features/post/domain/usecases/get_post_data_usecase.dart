import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class GetPostUsecase extends FutureUsecase<Post?, IdParam> {
  final PostRepository repository;

  GetPostUsecase(this.repository);

  @override
  ResultFuture<Post?> call(IdParam param) async {
    return await repository.getPostData(param.id);
  }
}
