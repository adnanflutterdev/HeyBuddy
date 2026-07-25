import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

abstract class ReplyTo {
  final String chatId;
  final String uid;
  final Timestamps timestamps;
  final Media? media;
  final String message;
  final MessageType type;

  ReplyTo({
    required this.chatId,
    required this.uid,
    required this.timestamps,
    required this.message,
    required this.type,
    this.media,
  });
}
