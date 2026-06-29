import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';

class FriendModel extends Friend {
  FriendModel({
    required super.friendId,
    required super.chatId,
    required super.friendSince,
  });

  factory FriendModel.fromEntity(Friend friend) {
    return FriendModel(
      friendId: friend.friendId,
      chatId: friend.chatId,
      friendSince: friend.friendSince,
    );
  }

  factory FriendModel.fromFirebase(Map<String, dynamic> friend) {
    return FriendModel(
      friendId: friend['friendId'],
      chatId: friend['chatId'],
      friendSince: (friend['friendSince'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'friendId': friendId,
      'chatId': chatId,
      'friendSince': Timestamp.fromDate(friendSince),
    };
  }
}
