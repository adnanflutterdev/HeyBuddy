import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:hey_buddy/features/chat/data/repository/chat_repository_impl.dart';
import 'package:hey_buddy/features/chat/domain/usecase/get_chats_usecase.dart';
import 'package:hey_buddy/features/chat/domain/usecase/get_all_conversations_usecase.dart';
import 'package:hey_buddy/features/chat/domain/usecase/get_conversation_usecase.dart';
import 'package:hey_buddy/features/chat/domain/usecase/send_chat_usecase.dart';
import 'package:hey_buddy/features/chat/domain/usecase/update_online_status_usecase.dart';
import 'package:hey_buddy/features/chat/domain/usecase/update_last_index_usecase.dart';

final chatRemoteDatasourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return ChatRemoteDataSource(firestore);
});

final chatRepositoryProvider = Provider((ref) {
  final chatRemoteDatasource = ref.read(chatRemoteDatasourceProvider);
  return ChatRepositoryImpl(chatRemoteDatasource);
});

final sendChatUsecaseProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return SendChatUsecase(chatRepository);
});

final getAllConversationsUsecaseProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetAllConversationsUsecase(chatRepository);
});

final getConversationUsecaseProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetConversationUsecase(chatRepository);
});

final getChatsUsecaseProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetChatsUsecase(chatRepository);
});

final updateLastIndexUsecaseProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return UpdateLastIndexUsecase(chatRepository);
});

final updateOnlineStatusUsecaseProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return UpdateOnlineStatusUsecase(chatRepository);
});
