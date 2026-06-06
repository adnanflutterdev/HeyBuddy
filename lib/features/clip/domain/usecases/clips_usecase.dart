import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/domain/repository/clip_repository.dart';

class ClipsUsecase extends StreamUsecase<List<Clip>,NoParams> {
  final ClipRepository repository;
  ClipsUsecase(this.repository);

  @override
  ResultStream<List<Clip>> call(NoParams noParams) {
    return repository.getAllClips();
  }
}
