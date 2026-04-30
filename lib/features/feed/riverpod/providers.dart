import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/feed/data/data_sources/feed_remote_data_source.dart';
import 'package:hey_buddy/features/feed/data/repository/feed_repository_impl.dart';
import 'package:hey_buddy/features/feed/domain/usecases/all_post_ids_usecase.dart';
import 'package:hey_buddy/features/feed/domain/usecases/get_post_data_usecase.dart';
import 'package:hey_buddy/features/feed/domain/usecases/post_like_stream_usecase.dart';
import 'package:hey_buddy/features/feed/domain/usecases/upload_feed_item_usecase.dart';

final postRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return FeedRemoteDataSource(firestore);
});

final postRepositoryProvider = Provider((ref) {
  final postRemoteDataSource = ref.read(postRemoteDataSourceProvider);
  return FeedRepositoryImpl(postRemoteDataSource);
});

final uploadFeedItemUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return UploadFeedItemUsecase(postRepository);
});

final allPostIdsUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return AllPostIdsUsecase(postRepository);
});
final getPostDataUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return GetPostDataUsecase(postRepository);
});

final postLikeStreamUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return PostLikeStreamUsecase(postRepository);
});
