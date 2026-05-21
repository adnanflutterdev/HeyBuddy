import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/media_meta.dart';
import 'package:hey_buddy/core/model/timestamps.dart';

enum Visibility { public, private, friendsOnly }

enum ModerationStatus { pending, approved, declined }

enum FeedType { post, clips }

enum MediaType { image, video }

abstract class Post {
  final String id;
  final String userId;
  final PostContent content;
  final Timestamps timestamps;
  final PostStatus status;
  final Location location;
  final Moderation moderation;
  final Shared shared;
  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamps,
    required this.status,
    required this.location,
    required this.moderation,
    required this.shared,
  });
}

abstract class PostContent {
  final String text;
  final List<Media>? media;
  final List<String>? tags;

  PostContent({required this.text, required this.media, required this.tags});
}

abstract class Media {
  final MediaType type;
  final MediaMeta data;
  Media({required this.data, required this.type});
}

abstract class PostStatus {
  final bool isEdited;
  final bool pinned;
  final bool allowComments;
  final Visibility visibility;
  PostStatus({
    this.isEdited = false,
    this.pinned = false,
    required this.allowComments,
    required this.visibility,
  });
}

abstract class Location {
  final double? lat;
  final double? lng;
  final String? placeName;
  Location({this.lat, this.lng, this.placeName});
}

abstract class Moderation {
  final ModerationStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reason;
  Moderation({
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.reason,
  });
}

abstract class Shared {
  final DocumentReference? originalFeedItemRef;
  final DocumentReference? sharedByRef;
  final String? sharedText;
  final DateTime? sharedAt;
  Shared({
    this.originalFeedItemRef,
    this.sharedByRef,
    this.sharedText,
    this.sharedAt,
  });
}
