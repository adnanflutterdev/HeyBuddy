import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/image_upload_data.dart';

enum Visibility { public, private, friendsOnly }

enum ModerationStatus { pending, approved, declined }

enum FeedType { post, clips }

enum MediaType { image, video }

abstract class FeedItemEntity {
  final String id;
  final FeedItemUserEntity user;
  final ContentEntity content;
  final TimestampsEntity timestamps;
  final StatusEntity status;
  final LocationEntity location;
  final ModerationEntity moderation;
  final SharedEntity shared;
  FeedItemEntity({
    required this.id,
    required this.user,
    required this.content,
    required this.timestamps,
    required this.status,
    required this.location,
    required this.moderation,
    required this.shared,
  });
}

abstract class FeedItemUserEntity {
  final DocumentReference ref;
  final String id;
  final String name;
  final String? profileImage;
  FeedItemUserEntity({
    required this.ref,
    required this.id,
    required this.name,
    this.profileImage,
  });
}

abstract class ContentEntity {
  final String text;
  final List<MediaEntity>? media;
  final List<String>? tags;
  final FeedType type;

  ContentEntity({
    required this.text,
    required this.media,
    required this.tags,
    required this.type,
  });
}

abstract class MediaEntity {
  final MediaType type;
  final ImageUploadData data;
  MediaEntity({required this.data, required this.type});
}

abstract class TimestampsEntity {
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  TimestampsEntity({required this.createdAt, this.updatedAt});
}

abstract class StatusEntity {
  final bool isEdited;
  final bool pinned;
  final bool allowComments;
  final Visibility visibility;
  StatusEntity({
    this.isEdited = false,
    this.pinned = false,
    required this.allowComments,
    required this.visibility,
  });
}

abstract class LocationEntity {
  final double? lat;
  final double? lng;
  final String? placeName;
  LocationEntity({this.lat, this.lng, this.placeName});
}

abstract class ModerationEntity {
  final ModerationStatus status;
  final String? reviewedBy;
  final Timestamp? reviewedAt;
  final String? reason;
  ModerationEntity({
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.reason,
  });
}

abstract class SharedEntity {
  final DocumentReference? originalFeedItemRef;
  final DocumentReference? sharedByRef;
  final String? sharedText;
  final Timestamp? sharedAt;
  SharedEntity({
    this.originalFeedItemRef,
    this.sharedByRef,
    this.sharedText,
    this.sharedAt,
  });
}
