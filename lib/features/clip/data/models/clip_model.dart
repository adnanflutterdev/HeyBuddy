import 'package:hey_buddy/core/model/post_and_clip.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';

class ClipModel extends Clip {
  ClipModel({
    required super.id,
    required super.userId,
    required super.content,
    required super.timestamps,
    required super.status,
    required super.location,
    required super.moderation,
    required super.shared,
  });

  factory ClipModel.fromEntity(Clip clip) {
    return ClipModel(
      id: clip.id,
      userId: clip.userId,
      content: ClipContentModel.fromEntity(clip.content),
      timestamps: TimestampsModel.fromEntity(clip.timestamps),
      status: StatusModel.fromEntity(clip.status),
      location: LocationModel.fromEntity(clip.location),
      moderation: ModerationModel.fromEntity(clip.moderation),
      shared: SharedModel.fromEntity(clip.shared),
    );
  }

  factory ClipModel.fromFirebase(Map<String, dynamic> clip) {
    return ClipModel(
      id: clip['id'],
      userId: clip['userId'],
      content: ClipContentModel.fromFirebase(clip['content'] ?? {}),
      timestamps: TimestampsModel.fromFirebase(clip['timestamps'] ?? {}),
      status: StatusModel.fromFirebase(clip['status'] ?? {}),
      location: LocationModel.fromFirebase(clip['location']),
      moderation: ModerationModel.fromFirebase(clip['moderation']),
      shared: SharedModel.fromFirebase(clip['shared']),
    );
  }

  factory ClipModel.setNewPost({
    required String id,
    required String userId,
    required ClipContentModel content,
  }) {
    return ClipModel(
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
      'content': (content as ClipContentModel).toFirebase(),
      'timestamps': (timestamps as TimestampsModel).toFirebase(),
      'status': (status as StatusModel).toFirebase(),
      'location': (location as LocationModel).toFirebase(),
      'moderation': (moderation as ModerationModel).toFirebase(),
      'shared': (shared as SharedModel).toFirebase(),
    };
  }
}

class ClipContentModel extends ClipContent {
  ClipContentModel({
    required super.text,
    required super.media,
    required super.tags,
  });

  factory ClipContentModel.fromEntity(ClipContent content) {
    return ClipContentModel(
      text: content.text,
      media: content.media,
      tags: content.tags,
    );
  }

  factory ClipContentModel.fromFirebase(Map<String, dynamic> content) {
    return ClipContentModel(
      text: content['text'],
      media: MediaModel.fromFirebase(content['media']!),
      tags: content['tags']?.cast<String>(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "text": text,
      "media": (media as MediaModel).toFirebase(),
      "tags": tags,
    };
  }
}
