import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/accept_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/add_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/reject_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/remove_friend_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/withdraw_request_usecase.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';

class SocialActionsNotifier extends StateNotifier<AsyncValue> {
  final AcceptFriendRequestUsecase acceptFriendRequestUsecase;
  final AddFriendRequestUsecase addFriendRequestUsecase;
  final RejectFriendRequestUsecase rejectFriendRequestUsecase;
  final RemoveFriendUsecase removeFriendUsecase;
  final WithdrawRequestUsecase withdrawRequestUsecase;

  SocialActionsNotifier({
    required this.acceptFriendRequestUsecase,
    required this.addFriendRequestUsecase,
    required this.rejectFriendRequestUsecase,
    required this.removeFriendUsecase,
    required this.withdrawRequestUsecase,
  }) : super(const AsyncData(null));

  Future<Result> acceptFriendRequest(AcceptFriendRequestParams params) async {
    state = const AsyncLoading();
    final result = acceptFriendRequestUsecase(params);
    state = const AsyncData(null);
    return result;
  }

  Future<Result> addFriendRequest(AddFriendRequestParams params) async {
    state = const AsyncLoading();
    final result = addFriendRequestUsecase(params);
    state = const AsyncData(null);
    return result;
  }

  Future<Result> rejectFriendRequest(DualIdParam params) async {
    state = const AsyncLoading();
    final result = rejectFriendRequestUsecase(params);
    state = const AsyncData(null);
    return result;
  }

  Future<Result> removeFriend(DualIdParam params) async {
    state = const AsyncLoading();
    final result = removeFriendUsecase(params);
    state = const AsyncData(null);
    return result;
  }

  Future<Result> withdrawRequest(DualIdParam params) async {
    state = const AsyncLoading();
    final result = withdrawRequestUsecase(params);
    state = const AsyncData(null);
    return result;
  }
}

final socialActionsProvider =
    StateNotifierProvider<SocialActionsNotifier, AsyncValue>((ref) {
      final acceptFriendRequestUsecase = ref.read(
        acceptFriendRequestUsecaseProvider,
      );
      final addFriendRequestUsecase = ref.read(addFriendRequestUsecaseProvider);
      final rejectFriendRequestUsecase = ref.read(
        rejectFriendRequestUsecaseProvider,
      );
      final removeFriendUsecase = ref.read(removeFriendUsecaseProvider);
      final withdrawRequestUsecase = ref.read(withdrawRequestUsecaseProvider);
      return SocialActionsNotifier(
        acceptFriendRequestUsecase: acceptFriendRequestUsecase,
        addFriendRequestUsecase: addFriendRequestUsecase,
        rejectFriendRequestUsecase: rejectFriendRequestUsecase,
        removeFriendUsecase: removeFriendUsecase,
        withdrawRequestUsecase: withdrawRequestUsecase,
      );
    });
