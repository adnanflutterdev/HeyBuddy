import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/domain/entity/seen.dart';

class SeenModel extends Seen {
  SeenModel({required super.isSeen, required super.seenAt});

  factory SeenModel.fromEntity(Seen seen) {
    return SeenModel(isSeen: seen.isSeen, seenAt: seen.seenAt);
  }

  factory SeenModel.fromFirebase(Map<String, dynamic> seen) {
    return SeenModel(
      isSeen: seen['isSeen'],
      seenAt: (seen['seenAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {'isSeen': isSeen, 'seenAt': Timestamp.fromDate(seenAt)};
  }
}
