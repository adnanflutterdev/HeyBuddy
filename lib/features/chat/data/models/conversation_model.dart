import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';

class ConversationModel extends Conversation {
  ConversationModel({
    super.lastChat,
    super.updatedAt,
    super.isFriendActive,
    super.lastIndex,
  });

  factory ConversationModel.fromFirebase(Map<String, dynamic> conversation) {
    return ConversationModel(
      lastChat: conversation['lastChat'],
      updatedAt: (conversation['updatedAt'] as Timestamp).toDate(),
      isFriendActive: conversation['isFriendActive'],
      lastIndex: conversation['lastIndex'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'lastChat': lastChat,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isFriendActive': isFriendActive ?? false,
      'lastIndex': lastIndex ?? -1,
    };
  }
}
