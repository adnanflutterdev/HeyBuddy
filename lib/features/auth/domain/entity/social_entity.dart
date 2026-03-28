import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SocialEntity {
  final List<FriendEntity> friendList;
  final List<String> followers;
  final List<String> following;
  final List<String> yourRequests;
  final List<String> otherRequests;
  SocialEntity({
    required this.friendList,
    required this.followers,
    required this.following,
    required this.yourRequests,
    required this.otherRequests,
  });
}

abstract class FriendEntity {
  final String friendId;
  final String chatId;
  final Timestamp createdAt;
  FriendEntity({required this.friendId, required this.chatId,required this.createdAt});
}
