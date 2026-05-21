import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Timestamps {
  final DateTime createdAt;
  final DateTime? updatedAt;
  Timestamps({required this.createdAt, this.updatedAt});
}

class TimestampsModel extends Timestamps {
  TimestampsModel({required super.createdAt, super.updatedAt});

  factory TimestampsModel.fromEntity(Timestamps timestamps) {
    return TimestampsModel(
      createdAt: timestamps.createdAt,
      updatedAt: timestamps.updatedAt,
    );
  }

  factory TimestampsModel.fromFirebase(Map<String, dynamic> timestamps) {
    return TimestampsModel(
      createdAt: (timestamps['createdAt'] as Timestamp).toDate(),
      updatedAt: (timestamps['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
