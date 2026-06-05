import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';

abstract class Clip {
  final String id;
  final String userId;
  final ClipContent content;
  final Timestamps timestamps;
  final Status status;
  final Location location;
  final Moderation moderation;
  final Shared shared;
  Clip({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamps,
    required this.status,
    required this.location,
    required this.moderation,
    required this.shared,
  });
}

abstract class ClipContent {
  final String? text;
  final Media media;
  final List<String>? tags;

  ClipContent({required this.text, required this.media, required this.tags});
}
