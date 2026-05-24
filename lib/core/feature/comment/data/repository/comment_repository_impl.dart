import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/feature/comment/data/datasource/comment_remote_datasource.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/feature/comment/domain/repository/comment_repository.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_comment_reply_usecase.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDatasource remote;

  CommentRepositoryImpl(this.remote);
  @override
  ResultFuture addComment(String postId, Comment comment) async {
    try {
      await remote.addComment(postId, CommentModel.fromEntity(comment));
      return Result.success('Comment added!!!');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to add comment');
    } catch (e) {
      return Result.failure('Failed to add comment');
    }
  }

  @override
  ResultFuture<void> addCommentReply(AddCommentReplyParams params) async {
    try {
      await remote.addCommentReply(
        id: params.id,
        commentId: params.commentId,
        commentReply: CommentModel.fromEntity(params.commentReply),
      );
      return Result.success('Reply added!!!');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to add reply');
    } catch (e) {
      return Result.failure('Failed to add reply');
    }
  }

  @override
  ResultStream<List<Comment>> getComments(String postId) {
    return remote.getComments(postId);
  }

  @override
  ResultFuture<void> addReaction({
    required String id,
    required String commentId,
    required Reaction reaction,
  }) async {
    try {
      await remote.addReaction(
        id: id,
        commentId: commentId,
        reaction: ReactionModel.fromEntity(reaction),
      );
      return Result.success('Reaction added!!!');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to add reaction');
    } catch (_) {
      return Result.failure('Failed to add reaction');
    }
  }

  @override
  ResultStream<List<Reaction>> getReactions({
    required String id,
    required String commentId,
  }) {
    return remote.getReactions(id: id, commentId: commentId);
  }
}
