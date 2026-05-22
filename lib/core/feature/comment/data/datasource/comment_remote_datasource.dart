import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/features/post/data/models/reaction_model.dart';

abstract class CommentRemoteDatasource {
  Stream<List<CommentModel>> getComments(String postId);
  Future<void> addComment(String postId, CommentModel comment);
  Future<void> addReaction({
    required String id,
    required String commentId,
    required ReactionModel reaction,
  });
}

class CommentRemoteDatasourceImpl implements CommentRemoteDatasource {
  final FirebaseFirestore firestore;
  CommentRemoteDatasourceImpl(this.firestore);

  @override
  Stream<List<CommentModel>> getComments(String id) {
    return firestore
        .collection('post')
        .doc(id)
        .collection('comments')
        .orderBy('timestamps.createdAt')
        .snapshots()
        .map(
          (snaphots) => snaphots.docs
              .map((doc) => CommentModel.fromFirebase(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> addComment(String id, CommentModel comment) async {
    firestore
        .collection('post')
        .doc(id)
        .collection('comments')
        .doc(comment.id)
        .set(comment.toFirebase());
  }

  @override
  Future<void> addReaction({
    required String id,
    required String commentId,
    required ReactionModel reaction,
  }) async {
    firestore
        .collection('post')
        .doc(id)
        .collection('comments')
        .doc(commentId)
        .collection('reactions')
        .doc(reaction.userId)
        .set(reaction.toFirebase());
  }
}
