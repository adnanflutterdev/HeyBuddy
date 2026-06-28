import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';
import 'package:rxdart/rxdart.dart';

class SocialInteractions {
  final List<Friend> friends;
  final List<FriendRequest> myFriendRequests;
  final List<FriendRequest> othersFriendRequests;

  SocialInteractions({
    required this.friends,
    required this.myFriendRequests,
    required this.othersFriendRequests,
  });

  List<String> getFriendsId() {
    return friends.map((friend) => friend.friendId).toList();
  }

  List<String> getMyFriendRequestsId() {
    return myFriendRequests.map((request) => request.requestId).toList();
  }

  List<String> getOthersFriendRequestsId() {
    return othersFriendRequests.map((request) => request.requestId).toList();
  }
}

Stream<SocialInteractions> socialInteractions(Ref ref) {
  IdParam param = IdParam(ref.watch(uidProvider));

  return Rx.combineLatest3(
    ref.read(getFriendsUsecaseProvider)(param),
    ref.read(getMyFriendRequestsUsecaseProvider)(param),
    ref.read(getOthersFriendRequestsUsecaseProvider)(param),
    (a, b, c) => SocialInteractions(
      friends: a,
      myFriendRequests: b,
      othersFriendRequests: c,
    ),
  );
}

final socialInteractionsProvider = StreamProvider<SocialInteractions>((ref) {
  return socialInteractions(ref);
});
