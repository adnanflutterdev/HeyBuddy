import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';

abstract class ChatRepository {
  ResultStream<List<Conversation?>> getConversation(String myUid);
  ResultFuture<void> sendChat({
    required String myUid,
    required String fUid,
    required String chatsDocId,
    required Chat chat,
    required bool chatDocExisits,
  });
}
