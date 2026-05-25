import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/model/reaction.dart';

abstract class CommentRepository {
  ResultFuture<void> addComment(DocumentReference ref, Comment comment);
  ResultFuture<void> addReaction(DocumentReference ref, Reaction reaction);
  ResultStream<List<CommentModel>> getComments(CollectionReference ref);
  ResultStream<List<ReactionModel>> getReactions(CollectionReference ref);
}
