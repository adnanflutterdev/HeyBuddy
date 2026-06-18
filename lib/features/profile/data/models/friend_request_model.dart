import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';

class FriendRequestModel extends FriendRequest {
  FriendRequestModel({required super.requestId, required super.requestDate});

  factory FriendRequestModel.fromFirebase(Map<String, dynamic> request) {
    return FriendRequestModel(
      requestId: request['requestId'],
      requestDate: (request['requestDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'requestId': requestId,
      'requestDate': Timestamp.fromDate(requestDate),
    };
  }
}
