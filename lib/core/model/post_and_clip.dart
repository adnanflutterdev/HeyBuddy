import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/core/model/media_meta.dart';

enum Visibility { public, private, friendsOnly }

enum ModerationStatus { pending, approved, declined }

enum MediaType { image, video,audio }

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

abstract class Media {
  final MediaType type;
  final MediaMeta data;
  Media({required this.data, required this.type});
}

abstract class Status {
  final bool isEdited;
  final bool pinned;
  final bool allowComments;
  final Visibility visibility;
  Status({
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

class StatusModel extends Status {
  StatusModel({
    required super.isEdited,
    required super.pinned,
    required super.allowComments,
    required super.visibility,
  });

  factory StatusModel.fromEntity(Status post) {
    return StatusModel(
      isEdited: post.isEdited,
      pinned: post.pinned,
      allowComments: post.allowComments,
      visibility: post.visibility,
    );
  }

  factory StatusModel.fromFirebase(Map<String, dynamic> status) {
    return StatusModel(
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
