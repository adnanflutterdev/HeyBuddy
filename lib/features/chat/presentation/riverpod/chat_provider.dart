import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/usecase/send_chat_usecase.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/providers.dart';

class ChatNotifier extends StateNotifier<AsyncValue> {
  final SendChatUsecase sendChatUsecase;

  ChatNotifier(this.sendChatUsecase) : super(const AsyncData(null));

  ResultFuture<void> sendChat(SendChatParams params) async {
    state = const AsyncLoading();
    final result = await sendChatUsecase(params);
    state = const AsyncData(null);
    return result;
  }
}

final chatProvider = StateNotifierProvider((ref) {
  final sendChatUsecase = ref.read(sendChatUsecaseProvider);
  return ChatNotifier(sendChatUsecase);
});

final getConversationsProvider =
    StreamProvider.family<List<Conversation?>, String>((ref, myUid) {
      final getConversationUsecase = ref.read(getConversationUsecaseProvider);
      return getConversationUsecase(IdParam(myUid));
    });
