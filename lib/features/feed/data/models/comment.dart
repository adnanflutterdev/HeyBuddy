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

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'userId': userId,
      'content': (content as CommentContent).toFirebase(),
      'timestamps': (timestamps as Timestamps).toFirebase(),
    };
  }
}

class CommentContent extends CommentContentEntity {
  CommentContent({required super.text, super.mediaEntity});

  factory CommentContent.fromFirebase(Map<String, dynamic> content) {
    return CommentContent(
      text: content['text'],
      mediaEntity: content['mediaEntity'] != null
          ? Media.fromFirebase(content['mediaEntity'])
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'text': text, 'mediaEntity': (mediaEntity as Media?)?.toFirebase()};
  }
}
