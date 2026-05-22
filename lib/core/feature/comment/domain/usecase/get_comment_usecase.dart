import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';

class GetCommentUsecase extends StreamUsecase<List<Comment>, IdParam> {
  final CommentRepository repository;
  GetCommentUsecase(this.repository);

  @override
  Stream<List<Comment>> call(IdParam param) {
    return repository.getComments(param.id);
  }
}
