import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/chat/data/models/seen_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

extension MessageTypeX on MessageType {
  static MessageType fromFirebase(String type) {
    return MessageType.values.firstWhere((t) => t.name == type);
  }
}

class ChatModel extends Chat {
  ChatModel({
    required super.uid,
    required super.message,
    required super.timestamps,
    required super.type,
    required super.seen,
    required super.isEdited,
    required super.media,
    required super.chatId,
  });

  factory ChatModel.fromEntity(Chat chat) {
    return ChatModel(
      chatId: chat.chatId,
      uid: chat.uid,
      message: chat.message,
      timestamps: TimestampsModel.fromEntity(chat.timestamps),
      type: chat.type,
      seen: SeenModel.fromEntity(chat.seen),
      isEdited: chat.isEdited,
      media: chat.media?.map((m) => MediaModel.fromEntity(m)).toList(),
    );
  }

  factory ChatModel.fromFirebase(Map<String, dynamic> chat) {
    return ChatModel(
      chatId: chat['chatId'],
      uid: chat['uid'],
      message: chat['message'],
      timestamps: TimestampsModel.fromFirebase(chat['timestamps']),
      type: MessageTypeX.fromFirebase(chat['type']),
      seen: SeenModel.fromFirebase(chat['seen']),
      isEdited: chat['isEdited'],
      media: (chat['media'] as List<dynamic>)
          .map((m) => MediaModel.fromFirebase(m))
          .toList(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'chatId': chatId,
      'uid': uid,
      'message': message,
      'timestamps': (timestamps as TimestampsModel).toFirebase(),
      'type': type.name,
      'seen': (seen as SeenModel).toFirebase(),
      'isEdited': isEdited,
      'media': media?.map((m) => (m as MediaModel).toFirebase()).toList(),
    };
  }
}
