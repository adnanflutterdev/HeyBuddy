import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/profile/domain/usecases/accept_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/add_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/get_friends_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/get_my_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/get_others_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/reject_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/remove_friend_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/update_my_data_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/get_my_data_usecase.dart';
import 'package:hey_buddy/features/profile/data/repository/my_data_repository_impl.dart';
import 'package:hey_buddy/features/profile/data/data_sources/my_data_remote_source.dart';
import 'package:hey_buddy/features/profile/domain/usecases/withdraw_request_usecase.dart';

final myDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return MyDataRemoteSource(firestore);
});

final myDataRepositoryProvider = Provider((ref) {
  final userRemoteDataSource = ref.read(myDataSourceProvider);
  return MyDataRepositoryImpl(userRemoteDataSource);
});

// My Data

final getMyDataUsecaseProvider = Provider((ref) {
  final myDataRepository = ref.read(myDataRepositoryProvider);
  return GetMyDataUsecase(myDataRepository);
});

final updateMyDataUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return UpdateMyDataUsecase(userRepository);
});

// Social Interactions

final getFriendsUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return GetFriendsUsecase(userRepository);
});

final getMyFriendRequestsUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return GetMyFriendRequestUsecase(userRepository);
});

final getOthersFriendRequestsUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return GetOthersFriendRequestUsecase(userRepository);
});

// Social actions

final acceptFriendRequestUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return AcceptFriendRequestUsecase(userRepository);
});

final addFriendRequestUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return AddFriendRequestUsecase(userRepository);
});

final rejectFriendRequestUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return RejectFriendRequestUsecase(userRepository);
});

final removeFriendUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return RemoveFriendUsecase(userRepository);
});

final withdrawRequestUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return WithdrawRequestUsecase(userRepository);
});
