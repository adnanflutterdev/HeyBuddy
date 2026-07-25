import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/features/chat/domain/entity/reply_to.dart';

class ChatReplyNotifier extends StateNotifier<ReplyTo?> {
  ChatReplyNotifier() : super(null);

  void startReply(ReplyTo replyTo) {
    state = replyTo;
  }

  void stopReply() {
    state = null;
  }
}

final chatReplyProvider =
    StateNotifierProvider.autoDispose<ChatReplyNotifier, ReplyTo?>(
      (ref) => ChatReplyNotifier(),
    );
