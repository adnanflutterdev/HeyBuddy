import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/feed/domain/entity/timestamps_entity.dart';

class Timestamps extends TimestampsEntity {
  Timestamps({required super.createdAt, super.updatedAt});

  factory Timestamps.fromFirebase(Map<String, dynamic> timestamps) {
    return Timestamps(
      createdAt: (timestamps['createdAt'] as Timestamp).toDate(),
      updatedAt: (timestamps['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
