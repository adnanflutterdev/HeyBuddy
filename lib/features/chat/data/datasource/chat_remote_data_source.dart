import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/data/models/conversation_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;
  ChatRemoteDataSource(this.firestore);

  Stream<List<ConversationModel?>> getConversation(String myUid) {
    return firestore
        .collection('user')
        .doc(myUid)
        .collection('conversations')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ConversationModel.fromFirebase(doc.data());
          }).toList();
        });
  }

  Future<void> sendChat({
    required String myUid,
    required String fUid,
    required String chatsDocId,
    required ChatModel chat,
    required bool chatDocExisits,
  }) async {
    final user = firestore.collection('user');
    final myChat = user.doc(myUid).collection('conversations').doc(chatsDocId);
    final fChat = user.doc(fUid).collection('conversations').doc(chatsDocId);

    if (!chatDocExisits) {
      myChat.set(ConversationModel(id: chatsDocId, fUid: fUid).toFirebase());
      fChat.set(ConversationModel(id: chatsDocId, fUid: myUid).toFirebase());
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

  Stream<List<ChatModel>> getChatStream(String uid, String chatDocId) {
    final chats = firestore
        .collection('user')
        .doc(uid)
        .collection('conversations')
        .doc(chatDocId)
        .collection('chats').orderBy('timestamps.createdAt');

    return chats.snapshots().map(
      (querySnaps) => querySnaps.docs
          .map((chat) => ChatModel.fromFirebase(chat.data()))
          .toList(),
    );
  }
}
