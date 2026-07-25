import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/reply_to.dart';

class ReplyToModel extends ReplyTo {
  ReplyToModel({
    required super.chatId,
    required super.uid,
    required super.timestamps,
    required super.media,
    required super.message,
    required super.type,
  });

  factory ReplyToModel.fromEntity(ReplyTo replyTo) {
    return ReplyToModel(
      chatId: replyTo.chatId,
      uid: replyTo.uid,
      timestamps: TimestampsModel.fromEntity(replyTo.timestamps),
      media: MediaModel.fromEntity(replyTo.media),
      message: replyTo.message,
      type: replyTo.type,
    );
  }

  factory ReplyToModel.fromFirebase(Map<String, dynamic> replyTo) {
    return ReplyToModel(
      chatId: replyTo['chatId'],
      uid: replyTo['uid'],
      timestamps: TimestampsModel.fromFirebase(replyTo['timestamps']),
      media: MediaModel.fromFirebase(replyTo['media']),
      message: replyTo['message'],
      type: MessageTypeX.fromFirebase(replyTo['type']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'chatId': chatId,
      'uid': uid,
      'timestamps': (timestamps as TimestampsModel).toFirebase(),
      'media': (media as MediaModel).toFirebase(),
      'message': message,
      'type': type.name,
    };
  }
}
