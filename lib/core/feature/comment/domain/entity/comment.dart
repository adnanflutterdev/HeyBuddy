import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.timestamps,
  });

  factory CommentModel.fromEntity(Comment comment) {
    return CommentModel(
      id: comment.id,
      userId: comment.userId,
      content: comment.content,
      timestamps: comment.timestamps,
    );
  }

  factory CommentModel.fromFirebase(Map<String, dynamic> comment) {
    return CommentModel(
      id: comment['id'],
      userId: comment['userId'],
      content: CommentContentModel.fromFirebase(comment['content']),
      timestamps: TimestampsModel.fromFirebase(comment['timestamps']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'userId': userId,
      'content': (content as CommentContentModel).toFirebase(),
      'timestamps': (timestamps as TimestampsModel).toFirebase(),
    };
  }
}

class CommentContentModel extends CommentContent {
  CommentContentModel({required super.text, super.media});

  factory CommentContentModel.fromEntity(CommentContent content) {
    return CommentContentModel(text: content.text,media: content.media);
  }

  factory CommentContentModel.fromFirebase(Map<String, dynamic> content) {
    return CommentContentModel(
      text: content['text'],
      media: content['media'] != null
          ? MediaModel.fromFirebase(content['media'])
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'text': text, 'media': (media as MediaModel?)?.toFirebase()};
  }
}
