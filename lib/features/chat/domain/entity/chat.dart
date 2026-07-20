import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/chat/domain/entity/seen.dart';

enum MessageType { text, image, video, audio }

abstract class Chat {
  final String uid;
  final String message;
  final Timestamps timestamps;
  final MessageType type;
  final Seen seen;
  final bool isEdited;
  final List<Media>? media;

  Chat({
    required this.uid,
    required this.message,
    required this.timestamps,
    required this.type,
    required this.seen,
    required this.isEdited,
    required this.media,
  });
}
