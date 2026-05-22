import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';
import 'package:hey_buddy/features/post/domain/usecases/upload_post_usecase.dart';
import 'package:hey_buddy/features/post/presentation/riverpod/providers.dart';

class UploadPostNotifier extends StateNotifier<AsyncValue> {
  final UploadPostUsecase uploadPostUsecase;
  UploadPostNotifier(this.uploadPostUsecase) : super(const AsyncData(null));

  Future<Result> uploadPost(Post post) async {
    state = const AsyncLoading();
    try {
      Result result = await uploadPostUsecase(UploadPostParams(post));
      state = const AsyncData(null);
      return result;
    } catch (_) {
      state = const AsyncData(null);
      return Result.failure('Something went wrong');
    }
  }
}

final createPostProvider = StateNotifierProvider((ref) {
  UploadPostUsecase createPostUsecase = ref.read(uploadPostUsecaseProvider);
  return UploadPostNotifier(createPostUsecase);
});

final postsProvider = StreamProvider((ref) {
  final postsUsecase = ref.read(postsUsecaseProvider);
  return postsUsecase(NoParams());
});

final postDataProvider = FutureProvider.family<Post, String>((
  ref,
  postId,
) async {
  final getPostData = ref.read(getPostDataUsecaseProvider);
  final result = await getPostData(IdParam(postId));
  return result.data ?? Future.error(result.message);
});

final postLikeStream = StreamProvider.autoDispose.family<List<String>, String>((
  ref,
  postId,
) {
  final postLikeStreamUsecase = ref.read(postLikeStreamUsecaseProvider);
  return postLikeStreamUsecase(IdParam(postId));
});
