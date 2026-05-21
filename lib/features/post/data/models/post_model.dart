import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/media_meta.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/features/post/domain/entity/post.dart';

extension VisibilityX on Visibility {
  static Visibility fromFirebase(String visibility) {
    return Visibility.values.firstWhere((v) => v.name == visibility);
  }
}

extension ModerationStatusX on ModerationStatus {
  static ModerationStatus fromFirebase(String moderation) {
    return ModerationStatus.values.firstWhere((m) => m.name == moderation);
  }
}

extension MediaTypeX on MediaType {
  static MediaType fromFirebase(String type) {
    return MediaType.values.firstWhere((t) => t.name == type);
  }
}

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
      status: PostStatusModel.fromEntity(post.status),
      location: LocationModel.fromEntity(post.location),
      moderation: ModerationModel.fromEntity(post.moderation),
      shared: SharedModel.fromEntity(post.shared),
    );
  }

  factory PostModel.fromFirebase(Map<String, dynamic> feedItem) {
    return PostModel(
      id: feedItem['id'],
      userId: feedItem['userId'],
      content: PostContentModel.fromFirebase(feedItem['content'] ?? {}),
      timestamps: TimestampsModel.fromFirebase(feedItem['timestamps'] ?? {}),
      status: PostStatusModel.fromFirebase(feedItem['status'] ?? {}),
      location: LocationModel.fromFirebase(feedItem['location']),
      moderation: ModerationModel.fromFirebase(feedItem['moderation']),
      shared: SharedModel.fromFirebase(feedItem['shared']),
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
      status: PostStatusModel(
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
      'status': (status as PostStatusModel).toFirebase(),
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

class MediaModel extends Media {
  MediaModel({required super.data, required super.type});

  factory MediaModel.fromEntity(Media media) {
    return MediaModel(data: media.data, type: media.type);
  }

  factory MediaModel.fromFirebase(Map<String, dynamic> media) {
    return MediaModel(
      type: MediaTypeX.fromFirebase(media['type']),
      data: MediaMeta.fromFirebase(media['data']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'data': data.toFirebase(), 'type': type.name};
  }
}

class PostStatusModel extends PostStatus {
  PostStatusModel({
    required super.isEdited,
    required super.pinned,
    required super.allowComments,
    required super.visibility,
  });

  factory PostStatusModel.fromEntity(PostStatus post) {
    return PostStatusModel(
      isEdited: post.isEdited,
      pinned: post.pinned,
      allowComments: post.allowComments,
      visibility: post.visibility,
    );
  }

  factory PostStatusModel.fromFirebase(Map<String, dynamic> status) {
    return PostStatusModel(
      isEdited: status['isEdited'] ?? false,
      pinned: status['pinned'] ?? false,
      allowComments: status['allowComments'] ?? true,
      visibility: VisibilityX.fromFirebase(status['visibility']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'isEdited': isEdited,
      'pinned': pinned,
      'allowComments': allowComments,
      'visibility': visibility.name,
    };
  }
}

class LocationModel extends Location {
  LocationModel({super.lat, super.lng, super.placeName});

  factory LocationModel.fromEntity(Location location) {
    return LocationModel(
      lat: location.lat,
      lng: location.lng,
      placeName: location.placeName,
    );
  }

  factory LocationModel.fromFirebase(Map<String, dynamic> location) {
    return LocationModel(
      lat: location['lat'],
      lng: location['lng'],
      placeName: location['placeName'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'lat': lat, 'lng': lng, 'placeName': placeName};
  }
}

class ModerationModel extends Moderation {
  ModerationModel({
    required super.status,
    super.reviewedBy,
    super.reviewedAt,
    super.reason,
  });

  factory ModerationModel.fromEntity(Moderation moderation) {
    return ModerationModel(
      status: moderation.status,
      reason: moderation.reason,
      reviewedAt: moderation.reviewedAt,
    );
  }

  factory ModerationModel.fromFirebase(Map<String, dynamic> moderation) {
    return ModerationModel(
      status: ModerationStatusX.fromFirebase(moderation['status']),
      reviewedBy: moderation['reviewedBy'],
      reviewedAt: moderation['reviewedAt'] != null
          ? (moderation['reviewedAt'] as Timestamp).toDate()
          : null,
      reason: moderation['reason'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'status': status.name,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt != null ? Timestamp.fromDate(reviewedAt!) : null,
      'reason': reason,
    };
  }
}

class SharedModel extends Shared {
  SharedModel({
    super.originalFeedItemRef,
    super.sharedByRef,
    super.sharedText,
    super.sharedAt,
  });

  factory SharedModel.fromEntity(Shared shared) {
    return SharedModel();
  }

  factory SharedModel.fromFirebase(Map<String, dynamic> shared) {
    return SharedModel(
      originalFeedItemRef: shared['originalFeedItemRef'] as DocumentReference?,
      sharedByRef: shared['sharedByRef'] as DocumentReference?,
      sharedText: shared['sharedText'],
      sharedAt: shared['sharedAt'] != null
          ? (shared['sharedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'originalFeedItemRef': originalFeedItemRef,
      'sharedByRef': sharedByRef,
      'sharedText': sharedText,
      'sharedAt': sharedAt != null ? Timestamp.fromDate(sharedAt!) : null,
    };
  }
}
