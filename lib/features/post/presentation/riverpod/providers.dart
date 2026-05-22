import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/post/data/data_sources/post_remote_data_source.dart';
import 'package:hey_buddy/features/post/data/repository/post_repository_impl.dart';
import 'package:hey_buddy/features/post/domain/usecases/posts_usecase.dart';
import 'package:hey_buddy/features/post/domain/usecases/get_post_data_usecase.dart';
import 'package:hey_buddy/features/post/domain/usecases/post_like_stream_usecase.dart';
import 'package:hey_buddy/features/post/domain/usecases/toggle_post_like_usecase.dart';
import 'package:hey_buddy/features/post/domain/usecases/upload_post_usecase.dart';

final postRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return PostRemoteDataSource(firestore);
});

final postRepositoryProvider = Provider((ref) {
  final postRemoteDataSource = ref.read(postRemoteDataSourceProvider);
  return PostRepositoryImpl(postRemoteDataSource);
});

final uploadPostUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return UploadPostUsecase(postRepository);
});

final postsUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return PostsUsecase(postRepository);
});
final getPostDataUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return GetPostUsecase(postRepository);
});

final postLikeStreamUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return PostLikeStreamUsecase(postRepository);
});

final togglePostLikeUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return TogglePostLikeUsecase(postRepository);
});
