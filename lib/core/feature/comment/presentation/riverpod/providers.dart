import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/feature/comment/data/datasource/comment_remote_datasource.dart';
import 'package:hey_buddy/core/feature/comment/data/repository/comment_repository_impl.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_comment_reply_usecase.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_comment_usecase.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_reaction_usecase.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/get_comment_usecase.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/get_reaction_usecase.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';

final postRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return CommentRemoteDatasourceImpl(firestore);
});

final postRepositoryProvider = Provider((ref) {
  final postRemoteDataSource = ref.read(postRemoteDataSourceProvider);
  return CommentRepositoryImpl(postRemoteDataSource);
});

final addCommentUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return AddCommentUsecase(postRepository);
});

final addCommentReplyUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return AddCommentReplyUsecase(postRepository);
});

final getCommentUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return GetCommentUsecase(postRepository);
});

final addReactionUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return AddReactionUsecase(postRepository);
});

final getReactionUsecaseProvider = Provider((ref) {
  final postRepository = ref.read(postRepositoryProvider);
  return GetReactionUsecase(postRepository);
});
