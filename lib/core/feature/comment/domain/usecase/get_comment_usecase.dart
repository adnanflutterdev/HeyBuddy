import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';

class GetCommentUsecase
    extends StreamUsecase<List<Comment>, CollectionReferenceParam> {
  final CommentRepository repository;
  GetCommentUsecase(this.repository);

  @override
  Stream<List<Comment>> call(CollectionReferenceParam param) {
    return repository.getComments(param.ref);
  }
}
