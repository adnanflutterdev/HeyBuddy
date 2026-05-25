import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_reaction_usecase.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/providers.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_comment_usecase.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class CommentNotifier extends StateNotifier<AsyncValue> {
  final AddCommentUsecase addCommentUsecase;
  final AddReactionUsecase addReactionUsecase;
  CommentNotifier({
    required this.addCommentUsecase,
    required this.addReactionUsecase,
  }) : super(const AsyncData(null));

  Future<Result> addComment(DocumentReference ref, Comment comment) async {
    state = const AsyncLoading();
    Result result = await addCommentUsecase(AddCommentParams(ref, comment));
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
  return CommentNotifier(
    addCommentUsecase: addCommentUsecase,
    addReactionUsecase: addReactionUsecase,
  );
});

final getCommentStream = StreamProvider.autoDispose
    .family<List<Comment>, CollectionReference>((ref, collRef) {
      final getCommentUsecase = ref.read(getCommentUsecaseProvider);
      return getCommentUsecase(CollectionReferenceParam(collRef));
    });

final getReactionStream = StreamProvider.autoDispose
    .family<List<Reaction>, CollectionReference>((ref, collRef) {
      final getReactionUsecase = ref.read(getReactionUsecaseProvider);
      return getReactionUsecase(CollectionReferenceParam(collRef));
    });
