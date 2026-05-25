import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/model/reaction.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';

abstract class CommentRemoteDatasource {
  Future<void> addComment(DocumentReference ref, CommentModel comment);
  Future<void> addReaction(DocumentReference ref, ReactionModel reaction);
  ResultStream<List<CommentModel>> getComments(CollectionReference ref);
  ResultStream<List<ReactionModel>> getReactions(CollectionReference ref);
}

class CommentRemoteDatasourceImpl implements CommentRemoteDatasource {
  final FirebaseFirestore firestore;
  CommentRemoteDatasourceImpl(this.firestore);

  @override
  Future<void> addComment(DocumentReference ref, CommentModel comment) async {
    await ref.set(comment.toFirebase());
  }

  @override
  Future<void> addReaction(
    DocumentReference ref,
    ReactionModel reaction,
  ) async {
    await ref.set(reaction.toFirebase());
  }

  @override
  Stream<List<CommentModel>> getComments(CollectionReference ref) {
    return ref
        .orderBy('timestamps.createdAt')
        .snapshots()
        .map(
          (snaphots) => snaphots.docs
              .map(
                (doc) => CommentModel.fromFirebase(
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  @override
  ResultStream<List<ReactionModel>> getReactions(CollectionReference ref) {
    return ref.snapshots().map(
      (snaphots) => snaphots.docs
          .map(
            (doc) =>
                ReactionModel.fromFirebase(doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
