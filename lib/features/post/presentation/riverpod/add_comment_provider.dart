import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/comment.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/post/domain/usecases/add_comment_usecase.dart';
import 'package:hey_buddy/features/post/presentation/riverpod/providers.dart';

class AddCommentNotifier extends StateNotifier<AsyncValue> {
  final AddCommentUsecase addCommentUsecase;
  AddCommentNotifier(this.addCommentUsecase) : super(const AsyncData(null));

  Future<Result> addComment(String postId, Comment comment) async {
    state = const AsyncLoading();
    Result result = await addCommentUsecase(postId, comment);
    state = const AsyncData(null);
    return result;
  }
}

final addCommentProvider =
    StateNotifierProvider<AddCommentNotifier, AsyncValue>((ref) {
      final addCommentUsecase = ref.read(addCommentUsecaseProvider);
      return AddCommentNotifier(addCommentUsecase);
    });
