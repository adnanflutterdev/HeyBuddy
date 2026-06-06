import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/domain/repository/clip_repository.dart';

class UploadClipUsecase extends FutureUsecase<void, UploadClipParams> {
  final ClipRepository repository;

  UploadClipUsecase(this.repository);

  @override
  Future<Result> call(UploadClipParams params) {
    return repository.uploadClip(params.clip);
  }
}

class UploadClipParams {
  final Clip clip;

  UploadClipParams(this.clip);
}
