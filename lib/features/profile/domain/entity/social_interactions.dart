import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';

class SocialInteractions {
  final List<Friend> friends;
  final List<FriendRequest> myFriendRequests;
  final List<FriendRequest> othersFriendRequests;

  SocialInteractions({
    required this.friends,
    required this.myFriendRequests,
    required this.othersFriendRequests,
  });

  List<String> _getFriendsId() {
    return friends.map((friend) => friend.friendId).toList();
  }

  List<String> _getMyFriendRequestsId() {
    return myFriendRequests.map((request) => request.requestId).toList();
  }

  List<String> _getOthersFriendRequestsId() {
    return othersFriendRequests.map((request) => request.requestId).toList();
  }

  Relations getRelations() {
    return Relations(
      friends: _getFriendsId(),
      myRequests: _getMyFriendRequestsId(),
      othersRequests: _getOthersFriendRequestsId(),
    );
  }
}

class Relations {
  final List<String> friends;
  final List<String> myRequests;
  final List<String> othersRequests;

  Relations({
    required this.friends,
    required this.myRequests,
    required this.othersRequests,
  });

  RelationStatus getRelationStatus(String uid) {
    return RelationStatus(
      isFriend: friends.contains(uid),
      isInMyRequests: myRequests.contains(uid),
      isInOthersRequests: othersRequests.contains(uid),
    );
  }
}

class RelationStatus {
  final bool isFriend;
  final bool isInMyRequests;
  final bool isInOthersRequests;

  RelationStatus({
    required this.isFriend,
    required this.isInMyRequests,
    required this.isInOthersRequests,
  });
}
