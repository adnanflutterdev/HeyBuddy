import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';


class FriendRequestModel extends FriendRequest {
  FriendRequestModel({
    required super.userId,
    required super.requestDate,
  });

  factory FriendRequestModel.fromEntity(FriendRequest request) {
    return FriendRequestModel(
      userId: request.userId,
      requestDate: request.requestDate,
    );
  }

  factory FriendRequestModel.fromFirebase(Map<String, dynamic> request) {
    return FriendRequestModel(
      userId: request['requestId'],
      requestDate: (request['requestDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'requestId': userId,
      'requestDate': Timestamp.fromDate(requestDate),
    };
  }
}
