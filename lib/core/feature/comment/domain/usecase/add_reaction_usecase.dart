import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class AddReactionUsecase extends FutureUsecase<void, AddReactionParams> {
  final CommentRepository repository;

  AddReactionUsecase(this.repository);
  @override
  ResultFuture<void> call(AddReactionParams params) {
    return repository.addReaction(params.ref, params.reaction);
  }
}

class AddReactionParams {
  final DocumentReference ref;
  final Reaction reaction;

  AddReactionParams(this.ref, this.reaction);
}
