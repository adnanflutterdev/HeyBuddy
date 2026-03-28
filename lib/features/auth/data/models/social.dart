import 'package:hey_buddy/features/auth/domain/entity/social_entity.dart';

class Social extends SocialEntity {
  Social({
    required super.friendList,
    required super.followers,
    required super.following,
    required super.yourRequests,
    required super.otherRequests,
  });

  factory Social.setNewUser() {
    return Social(
      friendList: [],
      followers: [],
      following: [],
      yourRequests: [],
      otherRequests: [],
    );
  }

  factory Social.fromFirebase(Map<String, dynamic> social) {
    return Social(
      friendList: (social['friendList'] as List<dynamic>? ?? [])
          .map(
            (friend) => Friend.fromFirebase(Map<String, dynamic>.from(friend)),
          )
          .toList(),
      followers: (social['followers'] ?? []).cast<String>(),
      following: (social['following'] ?? []).cast<String>(),
      yourRequests: (social['yourRequests'] ?? []).cast<String>(),
      otherRequests: (social['otherRequests'] ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      "friendList": (friendList as List<Friend>)
          .map((Friend friend) => friend.toFirebase())
          .toList(),
      "followers": followers,
      "following": following,
      "yourRequests": yourRequests,
      "otherRequests": otherRequests,
    };
  }
}

class Friend extends FriendEntity {
  Friend({
    required super.friendId,
    required super.chatId,
    required super.createdAt,
  });
  factory Friend.fromFirebase(Map<String, dynamic> friend) {
    return Friend(
      friendId: friend['friendId'],
      chatId: friend['chatId'],
      createdAt: friend['createdAt'],
    );
  }
  Map<String, dynamic> toFirebase() {
    return {'friendId': friendId, 'chatId': chatId, 'createdAt': createdAt};
  }
}
