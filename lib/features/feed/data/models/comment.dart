import 'package:hey_buddy/features/feed/data/models/feed_item.dart';
import 'package:hey_buddy/features/feed/data/models/timestamps.dart';
import 'package:hey_buddy/features/feed/domain/entity/comment_entity.dart';

class Comment extends CommentEntity {
  Comment({
    required super.id,
    required super.userId,
    required super.content,
    required super.timestamps,
  });

  factory Comment.fromFirebase(Map<String, dynamic> comment) {
    return Comment(
      id: comment['id'],
      userId: comment['userId'],
      content: CommentContent.fromFirebase(comment['content']),
      timestamps: Timestamps.fromFirebase(comment['timestamps']),
    );
  }
}

class CommentContent extends CommentContentEntity {
  CommentContent({required super.text, required super.mediaEntity});

  factory CommentContent.fromFirebase(Map<String, dynamic> content) {
    return CommentContent(
      text: content['text'],
      mediaEntity: Media.fromFirebase(content['mediaEntity']),
    );
  }
}
