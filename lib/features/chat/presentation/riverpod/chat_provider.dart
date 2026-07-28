import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/usecase/send_chat_usecase.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/providers.dart';

class ChatNotifier extends StateNotifier<AsyncValue> {
  final SendChatUsecase sendChatUsecase;

  ChatNotifier(
    this.sendChatUsecase,
  ) : super(const AsyncData(null));

  ResultFuture<void> sendChat(SendChatParams params) async {
    state = const AsyncLoading();
    final result = await sendChatUsecase(params);
    state = const AsyncData(null);
    return result;
  }
}

final chatProvider = StateNotifierProvider((ref) {
  final sendChatUsecase = ref.read(sendChatUsecaseProvider);
  return ChatNotifier(
    sendChatUsecase
  );
});

final getAllConversationsProvider =
    StreamProvider.family<List<Conversation?>, String>((ref, myUid) {
      final getAllConversationsUsecase = ref.read(
        getAllConversationsUsecaseProvider,
      );
      return getAllConversationsUsecase(IdParam(myUid));
    });

final getConversationProvider =
    StreamProvider.family<Conversation?, (String, String)>((ref, id) {
      final getConversationUsecase = ref.read(getConversationUsecaseProvider);
      return getConversationUsecase(DualIdParam(first: id.$1, second: id.$2));
    });

final getChatsProvider = StreamProvider.family<List<Chat>, (String, String)>((
  ref,
  params,
) {
  final getChatsUsecase = ref.read(getChatsUsecaseProvider);
  return getChatsUsecase(DualIdParam(first: params.$1, second: params.$2));
});

final getLastChatProvider = StreamProvider.family<Chat?, (String, String)>((
  ref,
  params,
) {
  final getLastChatUsecase = ref.read(getLastChatUsecaseProvider);
  return getLastChatUsecase(DualIdParam(first: params.$1, second: params.$2));
});
