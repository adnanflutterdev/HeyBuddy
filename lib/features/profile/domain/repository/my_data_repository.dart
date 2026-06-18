import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

abstract class MyDataRepository {
  ResultFuture<UserData> getMyData(String uid);
  ResultFuture updateMyData(String uid, Details details, Profile profile);
  ResultStream<List<Friend>> getFriends(String uid);
  ResultStream<List<FriendRequest>> getMyFriendRequests(String uid);
  ResultStream<List<FriendRequest>> getOthersFriendRequests(String uid);
}
