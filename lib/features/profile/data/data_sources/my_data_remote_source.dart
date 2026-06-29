import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_buddy/features/profile/data/models/friend_model.dart';
import 'package:hey_buddy/features/profile/data/models/friend_request_model.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';

class MyDataRemoteSource {
  final FirebaseFirestore firestore;

  MyDataRemoteSource(this.firestore);

  Future<Map<String, dynamic>?> getMyData(String uid) async {
    final doc = await firestore.collection('user').doc(uid).get();

    return doc.data();
  }

  Stream<List<Friend>> getFriends(String uid) {
    final snaphots = firestore
        .collection('user')
        .doc(uid)
        .collection('friends')
        .snapshots();

    return snaphots.map(
      (data) => data.docs
          .map((friend) => FriendModel.fromFirebase(friend.data()))
          .toList(),
    );
  }

  Stream<List<FriendRequest>> getMyFriendRequests(String uid) {
    final snaphots = firestore
        .collection('user')
        .doc(uid)
        .collection('friend_requests_sent')
        .snapshots();

    return snaphots.map(
      (data) => data.docs
          .map((request) => FriendRequestModel.fromFirebase(request.data()))
          .toList(),
    );
  }

  Stream<List<FriendRequest>> getOthersFriendRequests(String uid) {
    final snaphots = firestore
        .collection('user')
        .doc(uid)
        .collection('friend_requests')
        .snapshots();

    return snaphots.map(
      (data) => data.docs
          .map((request) => FriendRequestModel.fromFirebase(request.data()))
          .toList(),
    );
  }

  Future<void> updateMyData(
    String uid,
    DetailsModel details,
    ProfileModel profile,
  ) async {
    await firestore.collection('user').doc(uid).update({
      'details': details.toFirebase(),
      'profile': profile.toFirebase(),
    });
  }

  Future<void> addFriendRequest(
    FriendRequestModel mySide,
    FriendRequestModel userSide,
  ) async {
    // My Side
    await firestore
        .collection('user')
        .doc(userSide.userId)
        .collection('friend_requests_sent')
        .doc(mySide.userId)
        .set(mySide.toFirebase());

    // User's Side
    await firestore
        .collection('user')
        .doc(mySide.userId)
        .collection('friend_requests')
        .doc(userSide.userId)
        .set(userSide.toFirebase());
  }

  Future<void> acceptFriendRequest(
    FriendModel mySide,
    FriendModel friendSide,
  ) async {
    // My Side
    final myDoc = firestore.collection('user').doc(friendSide.friendId);
    await myDoc
        .collection('friends')
        .doc(mySide.friendId)
        .set(mySide.toFirebase());
    await myDoc.collection('friend_requests').doc(mySide.friendId).delete();

    // Friend's Side
    final friendsDoc = firestore.collection('user').doc(mySide.friendId);
    await friendsDoc
        .collection('friends')
        .doc(friendSide.friendId)
        .set(friendSide.toFirebase());
    await friendsDoc
        .collection('friend_requests_sent')
        .doc(friendSide.friendId)
        .delete();
  }

  Future<void> rejectFriendRequest(String myId, String friendId) async {
    // My Side
    await firestore
        .collection('user')
        .doc(myId)
        .collection('friend_requests')
        .doc(friendId)
        .delete();

    // User's Side
    await firestore
        .collection('user')
        .doc(friendId)
        .collection('friend_requests_sent')
        .doc(myId)
        .delete();
  }

  Future<void> removeFriend(String myId, String friendId) async {
    // My Side
    await firestore
        .collection('user')
        .doc(myId)
        .collection('friends')
        .doc(friendId)
        .delete();

    // Friend's Side
    await firestore
        .collection('user')
        .doc(friendId)
        .collection('friends')
        .doc(myId)
        .delete();
  }

  Future<void> withdrawRequest(String myId, String userId) async {
    // My Side
    await firestore
        .collection('user')
        .doc(myId)
        .collection('friend_requests_sent')
        .doc(userId)
        .delete();

    // User's Side
    await firestore
        .collection('user')
        .doc(userId)
        .collection('friend_requests')
        .doc(myId)
        .delete();
  }
}
