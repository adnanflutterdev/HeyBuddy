import 'package:cloud_firestore/cloud_firestore.dart';
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
    required super.user,
    required super.content,
    required super.timestamps,
    required super.status,
    required super.location,
    required super.moderation,
    required super.shared,
  });

  factory FeedItem.fromJson(Map<String, dynamic> feedItem) {
    return FeedItem(
      id: feedItem['id'] ?? '',
      user: FeedItemUser.fromJson(feedItem['user'] ?? {}),
      content: Content.fromJson(feedItem['content'] ?? {}),
      timestamps: Timestamps.fromJson(feedItem['timestamps'] ?? {}),
      status: Status.fromJson(feedItem['status'] ?? {}),
      location: Location.fromJson(feedItem['location']),
      moderation: Moderation.fromJson(feedItem['moderation']),
      shared: Shared.fromJson(feedItem['shared']),
    );
  }

  factory FeedItem.setNewPost({
    required String id,
    required FeedItemUser user,
    required Content content,
  }) {
    return FeedItem(
      id: id,
      user: user,
      content: content,
      timestamps: Timestamps(createdAt: Timestamp.now()),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': (user as FeedItemUser).toJson(),
      'content': (content as Content).toJson(),
      'timestamps': (timestamps as Timestamps).toJson(),
      'status': (status as Status).toJson(),
      'location': (location as Location).toJson(),
      'moderation': (moderation as Moderation).toJson(),
      'shared': (shared as Shared).toJson(),
    };
  }
}

class FeedItemUser extends FeedItemUserEntity {
  FeedItemUser({
    required super.ref,
    required super.id,
    required super.name,
    required super.profileImage,
  });

  factory FeedItemUser.fromJson(Map<String, dynamic> user) {
    return FeedItemUser(
      ref: user['ref'] as DocumentReference,
      id: user['id'] ?? '',
      name: user['name'] ?? 'Unknown',
      profileImage: user['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'ref': ref, 'id': id, 'name': name, 'profileImage': profileImage};
  }
}

class Content extends ContentEntity {
  Content({
    required super.text,
    required super.media,
    required super.tags,
    required super.type,
  });

  factory Content.fromJson(Map<String, dynamic> content) {
    return Content(
      text: content['text'],
      media: content['media'] != null
          ? (content['media'] as List<dynamic>)
                .map((media) => Media.fromJson(media as Map<String, dynamic>))
                .toList()
          : null,
      tags: content['tags']?.cast<String>(),
      type: FeedTypeX.fromFirebase(content['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "media": media?.map((medium) => (medium as Media).toJson()).toList(),
      "tags": tags,
      "type": type.name,
    };
  }
}

class Media extends MediaEntity {
  Media({required super.url, required super.type});
  factory Media.fromJson(Map<String, dynamic> media) {
    return Media(
      url: media['url'],
      type: MediaTypeX.fromFirebase(media['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'type': type.name};
  }
}

class Timestamps extends TimestampsEntity {
  Timestamps({required super.createdAt, super.updatedAt});

  factory Timestamps.fromJson(Map<String, dynamic> timestamps) {
    return Timestamps(
      createdAt: timestamps['createdAt'] ?? Timestamp.now(),
      updatedAt: timestamps['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class Status extends StatusEntity {
  Status({
    required super.isEdited,
    required super.pinned,
    required super.allowComments,
    required super.visibility,
  });

  factory Status.fromJson(Map<String, dynamic> status) {
    return Status(
      isEdited: status['isEdited'] ?? false,
      pinned: status['pinned'] ?? false,
      allowComments: status['allowComments'] ?? true,
      visibility: VisibilityX.fromFirebase(status['visibility']),
    );
  }

  Map<String, dynamic> toJson() {
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

  factory Location.fromJson(Map<String, dynamic> location) {
    return Location(
      lat: location['lat'],
      lng: location['lng'],
      placeName: location['placeName'],
    );
  }

  Map<String, dynamic> toJson() {
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

  factory Moderation.fromJson(Map<String, dynamic> moderation) {
    return Moderation(
      status: ModerationStatusX.fromFirebase(moderation['status']),
      reviewedBy: moderation['reviewedBy'],
      reviewedAt: moderation['reviewedAt'] as Timestamp?,
      reason: moderation['reason'],
    );
  }

  Map<String, dynamic> toJson() {
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

  factory Shared.fromJson(Map<String, dynamic> shared) {
    return Shared(
      originalFeedItemRef: shared['originalFeedItemRef'] as DocumentReference?,
      sharedByRef: shared['sharedByRef'] as DocumentReference?,
      sharedText: shared['sharedText'],
      sharedAt: shared['sharedAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originalFeedItemRef': originalFeedItemRef,
      'sharedByRef': sharedByRef,
      'sharedText': sharedText,
      'sharedAt': sharedAt,
    };
  }
}
