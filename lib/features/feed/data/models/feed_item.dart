import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/media_upload_data.dart';
import 'package:hey_buddy/features/feed/data/models/timestamps.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';

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

extension FeedTypeX on FeedType {
  static FeedType fromFirebase(String feedType) {
    return FeedType.values.firstWhere((type) => type.name == feedType);
  }
}

extension MediaTypeX on MediaType {
  static MediaType fromFirebase(String mediaType) {
    return MediaType.values.firstWhere((type) => type.name == mediaType);
  }
}

class FeedItem extends FeedItemEntity {
  FeedItem({
    required super.id,
    required super.userId,
    required super.content,
    required super.timestamps,
    required super.status,
    required super.location,
    required super.moderation,
    required super.shared,
  });

  factory FeedItem.fromFirebase(Map<String, dynamic> feedItem) {
    return FeedItem(
      id: feedItem['id'],
      userId: feedItem['userId'],
      content: Content.fromFirebase(feedItem['content'] ?? {}),
      timestamps: Timestamps.fromFirebase(feedItem['timestamps'] ?? {}),
      status: Status.fromFirebase(feedItem['status'] ?? {}),
      location: Location.fromFirebase(feedItem['location']),
      moderation: Moderation.fromFirebase(feedItem['moderation']),
      shared: Shared.fromFirebase(feedItem['shared']),
    );
  }

  factory FeedItem.setNewPost({
    required String id,
    required String userId,
    required Content content,
  }) {
    return FeedItem(
      id: id,
      userId: userId,
      content: content,
      timestamps: Timestamps(createdAt: DateTime.now()),
      status: Status(
        allowComments: true,
        visibility: .public,
        isEdited: false,
        pinned: false,
      ),
      location: Location(),
      moderation: Moderation(status: .approved),
      shared: Shared(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'userId': userId,
      'content': (content as Content).toFirebase(),
      'timestamps': (timestamps as Timestamps).toFirebase(),
      'status': (status as Status).toFirebase(),
      'location': (location as Location).toFirebase(),
      'moderation': (moderation as Moderation).toFirebase(),
      'shared': (shared as Shared).toFirebase(),
    };
  }
}

class Content extends ContentEntity {
  Content({
    required super.text,
    required super.media,
    required super.tags,
    required super.type,
  });

  factory Content.fromFirebase(Map<String, dynamic> content) {
    return Content(
      text: content['text'],
      media: content['media'] != null
          ? (content['media'] as List<dynamic>)
                .map(
                  (media) => Media.fromFirebase(media as Map<String, dynamic>),
                )
                .toList()
          : null,
      tags: content['tags']?.cast<String>(),
      type: FeedTypeX.fromFirebase(content['type']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "text": text,
      "media": media?.map((medium) => (medium as Media).toFirebase()).toList(),
      "tags": tags,
      "type": type.name,
    };
  }
}

class Media extends MediaEntity {
  Media({required super.data, required super.type});
  factory Media.fromFirebase(Map<String, dynamic> media) {
    return Media(
      type: MediaTypeX.fromFirebase(media['type']),
      data: MediaUploadData.fromFirebase(media['data']),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'data': data.toFirebase(), 'type': type.name};
  }
}

class Status extends StatusEntity {
  Status({
    required super.isEdited,
    required super.pinned,
    required super.allowComments,
    required super.visibility,
  });

  factory Status.fromFirebase(Map<String, dynamic> status) {
    return Status(
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

class Location extends LocationEntity {
  Location({super.lat, super.lng, super.placeName});

  factory Location.fromFirebase(Map<String, dynamic> location) {
    return Location(
      lat: location['lat'],
      lng: location['lng'],
      placeName: location['placeName'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'lat': lat, 'lng': lng, 'placeName': placeName};
  }
}

class Moderation extends ModerationEntity {
  Moderation({
    required super.status,
    super.reviewedBy,
    super.reviewedAt,
    super.reason,
  });

  factory Moderation.fromFirebase(Map<String, dynamic> moderation) {
    return Moderation(
      status: ModerationStatusX.fromFirebase(moderation['status']),
      reviewedBy: moderation['reviewedBy'],
      reviewedAt: moderation['reviewedAt'] as Timestamp?,
      reason: moderation['reason'],
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'status': status.name,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'reason': reason,
    };
  }
}

class Shared extends SharedEntity {
  Shared({
    super.originalFeedItemRef,
    super.sharedByRef,
    super.sharedText,
    super.sharedAt,
  });

  factory Shared.fromFirebase(Map<String, dynamic> shared) {
    return Shared(
      originalFeedItemRef: shared['originalFeedItemRef'] as DocumentReference?,
      sharedByRef: shared['sharedByRef'] as DocumentReference?,
      sharedText: shared['sharedText'],
      sharedAt: shared['sharedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'originalFeedItemRef': originalFeedItemRef,
      'sharedByRef': sharedByRef,
      'sharedText': sharedText,
      'sharedAt': sharedAt,
    };
  }
}
