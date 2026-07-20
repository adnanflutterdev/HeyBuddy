import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

abstract class ChatRepository {
  ResultFuture<void> sendChat({
    required String myUid,
    required String fUid,
    required String chatsDocId,
    required Chat chat,
  });
}
