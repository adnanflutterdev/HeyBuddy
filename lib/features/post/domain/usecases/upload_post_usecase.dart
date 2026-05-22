import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class UploadPostUsecase extends FutureUsecase<void, UploadPostParams> {
  final PostRepository repository;

  UploadPostUsecase(this.repository);

  @override
  Future<Result> call(UploadPostParams params) {
    return repository.uploadPost(params.post);
  }
}

class UploadPostParams {
  final Post post;

  UploadPostParams(this.post);
}
