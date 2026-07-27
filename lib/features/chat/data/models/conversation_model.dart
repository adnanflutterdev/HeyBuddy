import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/data/models/online_status_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';

class ConversationModel extends Conversation {
  ConversationModel({
    required super.id,
    required super.fUid,
    super.onlineStatus,
    super.lastChat,
    super.updatedAt,
    super.lastIndex,
  });

  factory ConversationModel.fromFirebase(Map<String, dynamic> conversation) {
    return ConversationModel(
      id: conversation['id'],
      fUid: conversation['fUid'],
      lastIndex: conversation['lastIndex'],
      onlineStatus: conversation['onlineStatus'] != null
          ? OnlineStatusModel.fromFirebase(conversation['onlineStatus'])
          : null,
      lastChat: ChatModel.fromFirebase(conversation['lastChat']),
      updatedAt: (conversation['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'fUid': fUid,
      'lastChat': lastChat,
      'lastIndex': lastIndex ?? 0,
      'onlineStatus': onlineStatus != null
          ? (onlineStatus as OnlineStatusModel).toFirebase()
          : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
