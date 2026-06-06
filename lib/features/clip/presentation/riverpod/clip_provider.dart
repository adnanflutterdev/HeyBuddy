import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/domain/usecases/upload_clip_usecase.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/providers.dart';

class UploadClipNotifier extends StateNotifier<AsyncValue> {
  final UploadClipUsecase uploadClipUsecase;
  UploadClipNotifier(this.uploadClipUsecase) : super(const AsyncData(null));

  Future<Result> uploadClip(Clip clip) async {
    state = const AsyncLoading();
    try {
      Result result = await uploadClipUsecase(UploadClipParams(clip));
      state = const AsyncData(null);
      return result;
    } catch (_) {
      state = const AsyncData(null);
      return Result.failure('Something went wrong');
    }
  }
}

final createClipProvider = StateNotifierProvider((ref) {
  UploadClipUsecase createClipUsecase = ref.read(uploadClipUsecaseProvider);
  return UploadClipNotifier(createClipUsecase);
});

final clipsProvider = StreamProvider((ref) {
  final clipsUsecase = ref.read(clipsUsecaseProvider);
  return clipsUsecase(NoParams());
});

final clipDataProvider = FutureProvider.family<Clip, String>((
  ref,
  clipId,
) async {
  final getClipData = ref.read(getClipDataUsecaseProvider);
  final result = await getClipData(IdParam(clipId));
  return result.data ?? Future.error(result.message);
});

final clipLikeStream = StreamProvider.autoDispose.family<List<String>, String>((
  ref,
  clipId,
) {
  final clipLikeStreamUsecase = ref.read(clipLikeStreamUsecaseProvider);
  return clipLikeStreamUsecase(IdParam(clipId));
});
