import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class GetReactionUsecase
    extends StreamUsecase<List<Reaction>, GetReactionParams> {
  final CommentRepository repository;

  GetReactionUsecase(this.repository);
  @override
  ResultStream<List<Reaction>> call(GetReactionParams params) {
    return repository.getReactions(id: params.id, commentId: params.commentId);
  }
}

class GetReactionParams {
  final String id;
  final String commentId;

  GetReactionParams({required this.id, required this.commentId});
}
