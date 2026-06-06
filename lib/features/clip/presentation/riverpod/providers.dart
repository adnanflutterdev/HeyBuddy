import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/clip/data/data_sources/clip_remote_data_source.dart';
import 'package:hey_buddy/features/clip/data/repository/clip_repository_impl.dart';
import 'package:hey_buddy/features/clip/domain/usecases/clips_usecase.dart';
import 'package:hey_buddy/features/clip/domain/usecases/get_clip_data_usecase.dart';
import 'package:hey_buddy/features/clip/domain/usecases/clip_like_stream_usecase.dart';
import 'package:hey_buddy/features/clip/domain/usecases/toggle_clip_like_usecase.dart';
import 'package:hey_buddy/features/clip/domain/usecases/upload_clip_usecase.dart';

final clipRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return ClipRemoteDataSource(firestore);
});

final clipRepositoryProvider = Provider((ref) {
  final clipRemoteDataSource = ref.read(clipRemoteDataSourceProvider);
  return ClipRepositoryImpl(clipRemoteDataSource);
});

final uploadClipUsecaseProvider = Provider((ref) {
  final clipRepository = ref.read(clipRepositoryProvider);
  return UploadClipUsecase(clipRepository);
});

final clipsUsecaseProvider = Provider((ref) {
  final clipRepository = ref.read(clipRepositoryProvider);
  return ClipsUsecase(clipRepository);
});
final getClipDataUsecaseProvider = Provider((ref) {
  final clipRepository = ref.read(clipRepositoryProvider);
  return GetClipUsecase(clipRepository);
});

final clipLikeStreamUsecaseProvider = Provider((ref) {
  final clipRepository = ref.read(clipRepositoryProvider);
  return ClipLikeStreamUsecase(clipRepository);
});

final toggleClipLikeUsecaseProvider = Provider((ref) {
  final clipRepository = ref.read(clipRepositoryProvider);
  return ToggleClipLikeUsecase(clipRepository);
});
