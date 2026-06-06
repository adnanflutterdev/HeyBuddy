import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/clip/domain/repository/clip_repository.dart';

class ClipLikeStreamUsecase extends StreamUsecase<List<String>, IdParam> {
  final ClipRepository repository;

  ClipLikeStreamUsecase(this.repository);

  @override
  ResultStream<List<String>> call(IdParam params) {
    return repository.getLikeStream(params.id);
  }
}
