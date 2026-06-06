import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/domain/repository/clip_repository.dart';

class GetClipUsecase extends FutureUsecase<Clip?, IdParam> {
  final ClipRepository repository;

  GetClipUsecase(this.repository);

  @override
  ResultFuture<Clip?> call(IdParam param) async {
    return await repository.getClipData(param.id);
  }
}
