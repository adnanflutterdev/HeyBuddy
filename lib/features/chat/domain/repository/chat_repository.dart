import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/entity/online_status.dart';

abstract class ChatRepository {
  ResultStream<List<Conversation?>> getAllConversations(String myUid);
  ResultStream<Conversation?> getConversation(
    String myUid,
    String chatDocId,
  );
  ResultStream<List<Chat>> getChats(String uid, String chatDocId);
  ResultStream<Chat?> getLastChat(String uid, String chatDocId);


  ResultFuture<void> sendChat({
    required String myUid,
    required String fUid,
    required String chatsDocId,
    required Chat chat,
    required bool chatDocExisits,
  });

  ResultFuture<void> updateLastIndex({
    required String uid,
    required String chatDocId,
    required int newIndex,
  });

  ResultFuture<void> updateOnlineStatus({
    required String fUid,
    required String chatDocId,
    required OnlineStatus onlineStatus,
  });
}
