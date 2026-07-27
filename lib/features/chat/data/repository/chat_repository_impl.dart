import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/data/models/online_status_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/entity/online_status.dart';
import 'package:hey_buddy/features/chat/domain/repository/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl(this.remote);

  @override
  ResultStream<List<Conversation?>> getAllConversations(String myUid) {
    try {
      return remote.getAllConversations(myUid);
    } on FirebaseException catch (e) {
      return Stream.error(e.message ?? 'Failed to fetch conversations');
    } catch (e) {
      return Stream.error('Failed to fetch conversations');
    }
  }

  @override
  ResultStream<Conversation?> getConversation(String myUid, String chatDocId) {
    try {
      return remote.getConversation(myUid, chatDocId);
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
  ResultStream<List<Chat>> getChats(String uid, String chatDocId) {
    try {
      return remote.getChats(uid, chatDocId);
    } on FirebaseException catch (e) {
      return Stream.error(e.message ?? 'Failed to send chat');
    } catch (e) {
      return Stream.error('Failed to send chat');
    }
  }

  @override
  ResultFuture<void> updateOnlineStatus({
    required String fUid,
    required String chatDocId,
    required OnlineStatus onlineStatus,
  }) async {
    try {
      await remote.updateActiveStatus(
        fUid: fUid,
        chatDocId: chatDocId,
        onlineStatus: OnlineStatusModel.fromEntity(onlineStatus),
      );
      return Result.success('Active status updated');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update active status');
    } catch (e) {
      return Result.failure('Failed to update active status');
    }
  }

  @override
  ResultFuture<void> updateLastIndex({
    required String uid,
    required String chatDocId,
    required int newIndex,
  }) async {
    try {
      await remote.updateLastIndex(
        uid: uid,
        chatDocId: chatDocId,
        newIndex: newIndex,
      );
      return Result.success('Last index updated');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update last index');
    } catch (e) {
      return Result.failure('Failed to update last index');
    }
  }
}
