import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.timestamps,
    required super.status,
    required super.location,
    required super.moderation,
    required super.shared,
  });

  factory PostModel.fromEntity(Post post) {
    return PostModel(
      id: post.id,
      userId: post.userId,
      content: PostContentModel.fromEntity(post.content),
      timestamps: TimestampsModel.fromEntity(post.timestamps),
      status: StatusModel.fromEntity(post.status),
      location: LocationModel.fromEntity(post.location),
      moderation: ModerationModel.fromEntity(post.moderation),
      shared: SharedModel.fromEntity(post.shared),
    );
  }

  factory PostModel.fromFirebase(Map<String, dynamic> post) {
    return PostModel(
      id: post['id'],
      userId: post['userId'],
      content: PostContentModel.fromFirebase(post['content'] ?? {}),
      timestamps: TimestampsModel.fromFirebase(post['timestamps'] ?? {}),
      status: StatusModel.fromFirebase(post['status'] ?? {}),
      location: LocationModel.fromFirebase(post['location']),
      moderation: ModerationModel.fromFirebase(post['moderation']),
      shared: SharedModel.fromFirebase(post['shared']),
    );
  }

  factory PostModel.setNewPost({
    required String id,
    required String userId,
    required PostContentModel content,
  }) {
    return PostModel(
      id: id,
      userId: userId,
      content: content,
      timestamps: TimestampsModel(createdAt: DateTime.now()),
      status: StatusModel(
        allowComments: true,
        visibility: .public,
        isEdited: false,
        pinned: false,
      ),
      location: LocationModel(),
      moderation: ModerationModel(status: .approved),
      shared: SharedModel(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'userId': userId,
      'content': (content as PostContentModel).toFirebase(),
      'timestamps': (timestamps as TimestampsModel).toFirebase(),
      'status': (status as StatusModel).toFirebase(),
      'location': (location as LocationModel).toFirebase(),
      'moderation': (moderation as ModerationModel).toFirebase(),
      'shared': (shared as SharedModel).toFirebase(),
    };
  }
}

class PostContentModel extends PostContent {
  PostContentModel({
    required super.text,
    required super.media,
    required super.tags,
  });

  factory PostContentModel.fromEntity(PostContent content) {
    return PostContentModel(
      text: content.text,
      media: content.media,
      tags: content.tags,
    );
  }

  factory PostContentModel.fromFirebase(Map<String, dynamic> content) {
    return PostContentModel(
      text: content['text'],
      media: content['media'] != null
          ? (content['media'] as List<dynamic>)
                .map(
                  (media) =>
                      MediaModel.fromFirebase(media as Map<String, dynamic>),
                )
                .toList()
          : null,
      tags: content['tags']?.cast<String>(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "text": text,
      "media": media
          ?.map((medium) => (medium as MediaModel).toFirebase())
          .toList(),
      "tags": tags,
    };
  }
}
