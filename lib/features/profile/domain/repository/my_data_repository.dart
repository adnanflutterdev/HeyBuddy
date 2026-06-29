import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class MyDataRepository {
  // My Data
  ResultFuture<UserData> getMyData(String uid);
  ResultFuture updateMyData(String uid, Details details, Profile profile);

  // Social Interactions
  ResultStream<List<Friend>> getFriends(String uid);
  ResultStream<List<FriendRequest>> getMyFriendRequests(String uid);
  ResultStream<List<FriendRequest>> getOthersFriendRequests(String uid);

  // Social actions
  ResultFuture<void> addFriendRequest(
    FriendRequest mySide,
    FriendRequest userSide,
  );
  ResultFuture<void> acceptFriendRequest(Friend mySide, Friend friendSide);
  ResultFuture<void> rejectFriendRequest(String myId, String friendId);
  ResultFuture<void> removeFriend(String myId, String friendId);
  ResultFuture<void> withdrawRequest(String myId, String userId);
}
