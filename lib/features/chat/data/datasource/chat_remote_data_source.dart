import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/data/models/conversation_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  ChatRemoteDataSource(this.firestore);

  Future<void> sendChat({
    required String myUid,
    required String fUid,
    required String chatsDocId,
    required ChatModel chat,
  }) async {
    final user = firestore.collection('user');
    final myChat = user.doc(myUid).collection('conversations').doc(chatsDocId);
    final fChat = user.doc(fUid).collection('conversations').doc(chatsDocId);

    final myChatGet = await myChat.get();
    final fChatGet = await myChat.get();

    ConversationModel conversation = ConversationModel();
    if (!myChatGet.exists) {
      myChat.set(conversation.toFirebase());
    }

    if (!fChatGet.exists) {
      fChat.set(conversation.toFirebase());
    }

    await myChat.collection('chats').doc(chat.chatId).set(chat.toFirebase());
    await fChat.collection('chats').doc(chat.chatId).set(chat.toFirebase());

    await myChat.update({
      'lastChat': chat.toFirebase(),
      'updatedAt': Timestamp.fromDate(chat.timestamps.createdAt),
    });
    await fChat.update({
      'lastChat': chat.toFirebase(),
      'updatedAt': Timestamp.fromDate(chat.timestamps.createdAt),
    });
  }
}
