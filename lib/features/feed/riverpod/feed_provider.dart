import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/feed/domain/usecases/upload_feed_item_usecase.dart';
import 'package:hey_buddy/features/feed/riverpod/providers.dart';

class UploadFeedItemNotifier extends StateNotifier<AsyncValue> {
  final UploadFeedItemUsecase uploadFeedItemUsecase;
  UploadFeedItemNotifier(this.uploadFeedItemUsecase)
    : super(const AsyncData(null));

  Future<Result> uploadFeedItem(FeedItemEntity post) async {
    state = const AsyncLoading();
    try {
      Result result = await uploadFeedItemUsecase(post);
      state = const AsyncData(null);
      return result;
    } catch (_) {
      state = const AsyncData(null);
      return Result.failure('Something went wrong');
    }
  }
}

final createPostProvider = StateNotifierProvider((ref) {
  UploadFeedItemUsecase createPostUsecase = ref.read(
    uploadFeedItemUsecaseProvider,
  );
  return UploadFeedItemNotifier(createPostUsecase);
});

final allPostIdsProvider = StreamProvider((ref) {
  final allPostIdsUsecase = ref.read(allPostIdsUsecaseProvider);
  return allPostIdsUsecase();
});

final postDataProvider = FutureProvider.family<FeedItemEntity?, String>((
  ref,
  postId,
) async {
  final getPostData = ref.read(getPostDataUsecaseProvider);
  return await getPostData(postId);
});
