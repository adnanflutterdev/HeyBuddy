import 'package:firebase_core/firebase_core.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/features/profile/data/data_sources/my_data_remote_source.dart';
import 'package:hey_buddy/features/profile/data/models/friend_model.dart';
import 'package:hey_buddy/features/profile/data/models/friend_request_model.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class MyDataRepositoryImpl extends MyDataRepository {
  final MyDataRemoteSource remote;

  MyDataRepositoryImpl(this.remote);
  @override
  ResultFuture<UserData> getMyData(String uid) async {
    try {
      Map<String, dynamic>? doc = await remote.getMyData(uid);

      UserDataModel user = UserDataModel.fromFirebase(doc ?? {});

      return Result<UserData>.success('Got User Data', data: user);
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Falied to fetch your data');
    } catch (_) {
      return Result.failure('Falied to fetch your data');
    }
  }

  @override
  ResultFuture updateMyData(
    String uid,
    Details details,
    Profile profile,
  ) async {
    try {
      DetailsModel detailsModel = DetailsModel.fromEntity(details);
      ProfileModel profileModel = ProfileModel.fromEntity(profile);
      await remote.updateMyData(uid, detailsModel, profileModel);
      return Result.success('Changes saved successfully');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Failed to update changes');
    } catch (_) {
      return Result.failure('Failed to update changes');
    }
  }

  @override
  ResultStream<List<Friend>> getFriends(String uid) {
    try {
      return remote.getFriends(uid);
    } on FirebaseException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(e);
    }
  }

  @override
  ResultStream<List<FriendRequest>> getMyFriendRequests(String uid) {
    try {
      return remote.getMyFriendRequests(uid);
    } on FirebaseException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(e);
    }
  }

  @override
  ResultStream<List<FriendRequest>> getOthersFriendRequests(String uid) {
    try {
      return remote.getOthersFriendRequests(uid);
    } on FirebaseException catch (e) {
      return Stream.error(e);
    } catch (e) {
      return Stream.error(e);
    }
  }

  @override
  ResultFuture<void> acceptFriendRequest(
    Friend mySide,
    Friend friendSide,
  ) async {
    try {
      await remote.acceptFriendRequest(
        FriendModel.fromEntity(mySide),
        FriendModel.fromEntity(friendSide),
      );
      return Result.success('Friend Request Accepted');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Falied to accept request');
    } catch (_) {
      return Result.failure('Falied to accept request');
    }
  }

  @override
  ResultFuture<void> addFriendRequest(
    FriendRequest mySide,
    FriendRequest userSide,
  ) async {
    try {
      await remote.addFriendRequest(
        FriendRequestModel.fromEntity(mySide),
        FriendRequestModel.fromEntity(userSide),
      );
      return Result.success('Friend Request Sent');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Falied to send request');
    } catch (_) {
      return Result.failure('Falied to send request');
    }
  }

  @override
  ResultFuture<void> rejectFriendRequest(String myId, String friendId) async {
    try {
      await remote.rejectFriendRequest(myId, friendId);
      return Result.success('Friend Requset Rejected');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Falied to reject request');
    } catch (_) {
      return Result.failure('Falied to reject request');
    }
  }

  @override
  ResultFuture<void> removeFriend(String myId, String friendId) async {
    try {
      await remote.removeFriend(myId, friendId);
      return Result.success('You are no longer friends');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Falied to remove friend');
    } catch (_) {
      return Result.failure('Falied to remove friend');
    }
  }

  @override
  ResultFuture<void> withdrawRequest(String myId, String userId) async {
    try {
      await remote.withdrawRequest(myId, userId);
      return Result.success('Friend Request Withdrawn');
    } on FirebaseException catch (e) {
      return Result.failure(e.message ?? 'Falied to withdraw request');
    } catch (_) {
      return Result.failure('Falied to withdraw request');
    }
  }
}
