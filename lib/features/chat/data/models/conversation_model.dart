import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';

class ConversationModel extends Conversation {
  ConversationModel({required super.id, required super.fUid, super.updatedAt});

  factory ConversationModel.fromFirebase(Map<String, dynamic> conversation) {
    return ConversationModel(
      id: conversation['id'],
      fUid: conversation['fUid'],
      updatedAt: (conversation['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'fUid': fUid,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
