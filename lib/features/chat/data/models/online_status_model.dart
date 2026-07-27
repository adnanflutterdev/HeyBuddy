import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/chat/domain/entity/online_status.dart';

class OnlineStatusModel extends OnlineStatus {
  OnlineStatusModel({required super.isOnline, super.lastSeen});

  factory OnlineStatusModel.fromEntity(OnlineStatus status) {
    return OnlineStatusModel(
      isOnline: status.isOnline,
      lastSeen: status.lastSeen,
    );
  }

  factory OnlineStatusModel.fromFirebase(Map<String, dynamic> status) {
    return OnlineStatusModel(
      isOnline: status['isOnline'],
      lastSeen: status['lastSeen'] != null
          ? (status['lastSeen'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
    };
  }
}
