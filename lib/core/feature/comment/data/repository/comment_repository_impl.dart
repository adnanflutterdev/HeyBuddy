import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/data/datasource/comment_remote_datasource.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDatasource remote;

  CommentRepositoryImpl(this.remote);
  @override
  ResultFuture addComment(DocumentReference ref, Comment comment) async {
    try {
      await remote.addComment(ref, CommentModel.fromEntity(comment));
      return Result.success('Comment added!!!');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to add comment');
    } catch (e) {
      return Result.failure('Failed to add comment');
    }
  }

  @override
  ResultFuture<void> addReaction(
    DocumentReference ref,
    Reaction reaction,
  ) async {
    try {
      await remote.addReaction(ref, ReactionModel.fromEntity(reaction));
      return Result.success('Reaction added!!!');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to add reaction');
    } catch (_) {
      return Result.failure('Failed to add reaction');
    }
  }

  @override
  ResultStream<List<CommentModel>> getComments(CollectionReference ref) {
    return remote.getComments(ref);
  }

  @override
  ResultStream<List<ReactionModel>> getReactions(CollectionReference ref) {
    return remote.getReactions(ref);
  }
}
