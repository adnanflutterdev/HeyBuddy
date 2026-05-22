import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/entity/reaction.dart';

class AddReactionUsecase extends FutureUsecase<void,AddReactionParams>{
  final CommentRepository repository;

  AddReactionUsecase(this.repository);
  @override
  ResultFuture<void> call(AddReactionParams params) {
    return repository.addReaction(id: params.id, commentId: params.commentId, reaction: params.reaction);
  }
}

class AddReactionParams{
  final String id;
    final String commentId;
    final Reaction reaction;

  AddReactionParams({required this.id, required this.commentId, required this.reaction});
}