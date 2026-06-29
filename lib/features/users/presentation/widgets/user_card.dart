import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/profile/data/models/friend_model.dart';
import 'package:hey_buddy/features/profile/data/models/friend_request_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/social_interactions.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/usecases/accept_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/add_friend_request_usecase.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/social_actions_provider.dart';
import 'package:uuid/uuid.dart';

class UserCard extends ConsumerWidget {
  const UserCard({super.key, required this.user, required this.status});
  final UserData user;
  final RelationStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUid = ref.watch(uidProvider);
    final socialActionsRef = ref.watch(socialActionsProvider);
    final socialActionsNotifier = ref.watch(socialActionsProvider.notifier);

    void acceptFriendRequest() async {
      DateTime now = DateTime.now();
      String chatId = const Uuid().v4();
      AcceptFriendRequestParams params = AcceptFriendRequestParams(
        first: FriendModel(
          friendId: user.uid,
          chatId: chatId,
          friendSince: now,
        ),
        second: FriendModel(friendId: myUid, chatId: chatId, friendSince: now),
      );
      final result = await socialActionsNotifier.acceptFriendRequest(params);
      if (context.mounted) {
        showMessenger(context, result: result);
      }
    }

    void addFriendRequest() async {
      DateTime now = DateTime.now();
      AddFriendRequestParams params = AddFriendRequestParams(
        first: FriendRequestModel(userId: user.uid, requestDate: now),
        second: FriendRequestModel(userId: myUid, requestDate: now),
      );
      final result = await socialActionsNotifier.addFriendRequest(params);
      if (context.mounted) {
        showMessenger(context, result: result);
      }
    }

    void rejectFriendRequest() async {
      DualIdParam params = DualIdParam(first: myUid, second: user.uid);
      final result = await socialActionsNotifier.rejectFriendRequest(params);
      if (context.mounted) {
        showMessenger(context, result: result);
      }
    }

    void removeFriend() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Remove Friend'),
            content: Text(
              'Are you sure to remove @${user.details.username} from friends',
            ),
            actions: [
              AppMeterialButton(
                text: 'Cancel',
                onPressed: () {
                  AppNavigator.pop();
                },
              ),
              AppMeterialButton(
                text: 'Remove',
                borderColor: context.colors.error,
                bgColor: context.colors.onError,
                style: context.style.b2.copyWith(color: context.colors.error),
                onPressed: () async {
                  DualIdParam params = DualIdParam(
                    first: myUid,
                    second: user.uid,
                  );
                  final result = await socialActionsNotifier.removeFriend(
                    params,
                  );
                  if (context.mounted) {
                    showMessenger(context, result: result);
                  }
                  AppNavigator.pop();
                },
              ),
            ],
          );
        },
      );
    }

    void withdrawRequest() async {
      DualIdParam params = DualIdParam(first: myUid, second: user.uid);
      final result = await socialActionsNotifier.withdrawRequest(params);
      if (context.mounted) {
        showMessenger(context, result: result);
      }
    }

    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: AppPadding.h12,
            child: Row(
              mainAxisAlignment: .center,
              children: [
                ProfileImage(imageUrl: user.profile.profileImage, size: 50),
                AppSpacing.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        '@${user.details.username}',
                        style: context.style.b1,
                      ),
                      Text(
                        user.details.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: context.style.bs1,
                      ),
                    ],
                  ),
                ),
                socialActionsRef.when(
                  data: (data) {
                    if (socialActionsRef.isLoading) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      );
                    } else if (myUid == user.uid) {
                      return const Text('Me');
                    } else if (status.isInOthersRequests) {
                      return Row(
                        children: [
                          AppSpacing.w8,
                          AppMeterialButton(
                            onPressed: acceptFriendRequest,
                            text: 'Accept',
                            icon: Icons.check,
                            borderRadius: 8,
                            iconAlignment: .end,
                            iconColor: context.colors.success,
                          ),
                          AppSpacing.w8,
                          AppMeterialButton(
                            onPressed: rejectFriendRequest,
                            borderRadius: 8,
                            icon: Icons.close,
                            iconAlignment: .end,
                            iconColor: context.colors.error,
                          ),
                        ],
                      );
                    } else if (status.isInMyRequests) {
                      return AppMeterialButton(
                        onPressed: withdrawRequest,
                        text: 'Withdraw',
                        icon: Icons.person_remove,
                        iconAlignment: .end,
                      );
                    } else {
                      return AppMeterialButton(
                        onPressed: status.isFriend
                            ? removeFriend
                            : addFriendRequest,
                        text: status.isFriend ? 'Friends' : 'Add',
                        icon: status.isFriend
                            ? Icons.person
                            : Icons.person_add_alt_1,
                        iconAlignment: .end,
                        style: status.isFriend
                            ? context.style.b2.copyWith(
                                color: context.colors.neonBlue,
                              )
                            : null,
                        iconColor: status.isFriend
                            ? context.colors.neonBlue
                            : null,
                        borderRadius: 8,
                        padding: AppPadding.symmetric(10, 6),
                      );
                    }
                  },

                  error: error,
                  loading: loader,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: AppPadding.symmetric(4, 8),
          child: const Divider(thickness: 0.5),
        ),
      ],
    );
  }
}
