import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';

abstract class Comment {
  final String id;
  final String userId;
  final CommentContent content;
  final Timestamps timestamps;

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamps,
  });
}

abstract class CommentContent {
  final String? text;
  final Media? media;

  CommentContent({required this.text, this.media});
}