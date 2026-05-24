import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';

class AddCommentReplyUsecase
    extends FutureUsecase<void, AddCommentReplyParams> {
  final CommentRepository repository;

  AddCommentReplyUsecase(this.repository);

  @override
  Future<Result> call(AddCommentReplyParams params) {
    return repository.addCommentReply(params);
  }
}

class AddCommentReplyParams {
  final String id;
  final String commentId;
  final Comment commentReply;

  AddCommentReplyParams({
    required this.id,
    required this.commentId,
    required this.commentReply,
  });
}
