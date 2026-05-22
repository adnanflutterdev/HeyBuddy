import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/repository/post_repository.dart';

class PostLikeStreamUsecase
    extends StreamUsecase<List<String>, IdParam> {
  final PostRepository repository;

  PostLikeStreamUsecase(this.repository);

  @override
  ResultStream<List<String>> call(IdParam params) {
    return repository.getLikeStream(params.id);
  }
}


