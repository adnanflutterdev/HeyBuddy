import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/post/data/models/post_model.dart';
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

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.timestamps,
  });

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
