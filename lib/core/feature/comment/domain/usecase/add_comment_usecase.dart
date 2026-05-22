import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';

class AddCommentUsecase extends FutureUsecase<void, AddCommentParams> {
  final CommentRepository repository;

  AddCommentUsecase(this.repository);

  @override
  Future<Result> call(AddCommentParams params) {
    return repository.addComment(params.id, params.comment);
  }
}

class AddCommentParams {
  final String id;
  final Comment comment;

  AddCommentParams(this.id, this.comment);
}
