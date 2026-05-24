import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/model/reaction.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';

abstract class CommentRemoteDatasource {
  Stream<List<CommentModel>> getComments(String postId);
  Future<void> addComment(String postId, CommentModel comment);
  Future<void> addCommentReply({
    required String id,
    required String commentId,
    required CommentModel commentReply,
  });
  Future<void> addReaction({
    required String id,
    required String commentId,
    required ReactionModel reaction,
  });
  ResultStream<List<ReactionModel>> getReactions({
    required String id,
    required String commentId,
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
  Future<void> addCommentReply({
    required String id,
    required String commentId,
    required CommentModel commentReply,
  }) async {
    firestore
        .collection('post')
        .doc(id)
        .collection('comments')
        .doc(commentId)
        .collection('reply')
        .doc(commentReply.id)
        .set(commentReply.toFirebase());
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

    // .doc('${reaction.userId}${DateTime.now()}')
    // For adding multiple Reactions with same id
  }

  @override
  ResultStream<List<ReactionModel>> getReactions({
    required String id,
    required String commentId,
  }) {
    return firestore
        .collection('post')
        .doc(id)
        .collection('comments')
        .doc(commentId)
        .collection('reactions')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ReactionModel.fromFirebase(doc.data()))
              .toList(),
        );
  }
}
