import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl(this.remote);

  @override
  ResultStream<List<Conversation?>> getConversation(String myUid) {
    try {
      return remote.getConversation(myUid);
    } on FirebaseException catch (e) {
      return Stream.error(e.message ?? 'Failed to fetch conversation');
    } catch (e) {
      return Stream.error('Failed to fetch conversation');
    }
  }

  @override
  ResultFuture<void> sendChat({
    required String myUid,
    required String fUid,
    required String chatsDocId,
    required Chat chat,
    required bool chatDocExisits,
  }) async {
    try {
      await remote.sendChat(
        myUid: myUid,
        fUid: fUid,
        chatsDocId: chatsDocId,
        chat: ChatModel.fromEntity(chat),
        chatDocExisits: chatDocExisits,
      );
      return Result.success('Chat sent!');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to send chat');
    } catch (e) {
      return Result.failure('Failed to send chat');
    }
  }

  @override
  ResultStream<List<Chat>> getChatStream(String uid, String chatDocId) {
    try {
      return remote.getChatStream(uid, chatDocId);
    } on FirebaseException catch (e) {
      return Stream.error(e.message ?? 'Failed to send chat');
    } catch (e) {
      return Stream.error('Failed to send chat');
    }
  }
}
