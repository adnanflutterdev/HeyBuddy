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
        .collection('my_friend_requests')
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
        .collection('others_friend_requests')
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
}
