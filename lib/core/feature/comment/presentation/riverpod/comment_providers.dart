import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_reaction_usecase.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/providers.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_comment_usecase.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';

class CommentNotifier extends StateNotifier<AsyncValue> {
  final AddCommentUsecase addCommentUsecase;
  final AddReactionUsecase addReactionUsecase;
  CommentNotifier(this.addCommentUsecase, this.addReactionUsecase)
    : super(const AsyncData(null));

  Future<Result> addComment(String postId, Comment comment) async {
    state = const AsyncLoading();
    Result result = await addCommentUsecase(AddCommentParams(postId, comment));
    state = const AsyncData(null);
    return result;
  }

  Future<Result> addReaction(AddReactionParams params) async {
    state = const AsyncLoading();
    Result result = await addReactionUsecase(params);
    state = const AsyncData(null);
    return result;
  }
}

final commentProvider = StateNotifierProvider<CommentNotifier, AsyncValue>((
  ref,
) {
  final addCommentUsecase = ref.read(addCommentUsecaseProvider);
  final addReactionUsecase = ref.read(addReactionUsecaseProvider);
  return CommentNotifier(addCommentUsecase, addReactionUsecase);
});

final getCommentStream = StreamProvider.family<List<Comment>, String>((
  ref,
  id,
) {
  final getCommentUsecase = ref.read(getCommentUsecaseProvider);
  return getCommentUsecase(IdParam(id));
});

