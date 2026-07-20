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
  const UserCard({
    super.key,
    required this.user,
    required this.status,
    this.onPressed,
    this.isOnUsersTab = true,
  });
  final UserData user;
  final RelationStatus status;
  final bool isOnUsersTab;

  final VoidCallback? onPressed;

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
              AppMaterialButton(
                text: 'Cancel',
                onPressed: () {
                  AppNavigator.pop();
                },
              ),
              AppMaterialButton(
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
            padding: isOnUsersTab ? AppPadding.h12 : AppPadding.p0,
            child: Row(
              mainAxisAlignment: .center,
              children: [
                ProfileImage(
                  imageUrl: user.profile.profileImage,
                  size: isOnUsersTab ? 50 : 40,
                  onTap: onPressed,
                ),
                AppSpacing.w12,
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          '@${user.details.username}',
                          style: context.style.b1.copyWith(
                            color: isOnUsersTab ? null : Colors.white,
                          ),
                        ),

                        Text(
                          user.details.name,
                          maxLines: 2,
                          overflow: .ellipsis,
                          style: context.style.bs1.copyWith(
                            color: isOnUsersTab ? null : Colors.white,
                          ),
                        ),
                      ],
                    ),
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
                    } else if (status.isInOthersRequests) {
                      return Row(
                        children: [
                          AppSpacing.w8,
                          AppMaterialButton(
                            onPressed: acceptFriendRequest,
                            text: 'Accept',
                            icon: Icons.check,
                            borderRadius: 8,
                            iconAlignment: .end,
                            iconColor: context.colors.success,
                            bgColor: !isOnUsersTab ? Colors.transparent : null,
                            borderColor: !isOnUsersTab ? Colors.white : null,
                          ),
                          AppSpacing.w8,
                          AppMaterialButton(
                            onPressed: rejectFriendRequest,
                            borderRadius: 8,
                            icon: Icons.close,
                            iconAlignment: .end,
                            iconColor: context.colors.error,
                            bgColor: !isOnUsersTab ? Colors.transparent : null,
                            borderColor: !isOnUsersTab ? Colors.white : null,
                          ),
                        ],
                      );
                    } else if (status.isInMyRequests) {
                      return AppMaterialButton(
                        onPressed: withdrawRequest,
                        text: 'Withdraw',
                        icon: Icons.person_remove,
                        iconAlignment: .end,
                        iconColor: !isOnUsersTab ? Colors.white : null,
                        style: !isOnUsersTab
                            ? context.style.b2.copyWith(color: Colors.white)
                            : null,
                        bgColor: !isOnUsersTab ? Colors.transparent : null,
                        borderColor: !isOnUsersTab ? Colors.white : null,
                      );
                    } else if (user.uid != myUid) {
                      return AppMaterialButton(
                        onPressed: status.isFriend
                            ? removeFriend
                            : addFriendRequest,
                        text: status.isFriend ? 'Friends' : 'Add',
                        icon: status.isFriend
                            ? Icons.person
                            : Icons.person_add_alt_1,
                        iconAlignment: .end,
                        style: context.style.b2.copyWith(
                          color: status.isFriend
                              ? context.colors.neonBlue
                              : !isOnUsersTab
                              ? Colors.white
                              : null,
                        ),
                        iconColor: status.isFriend
                            ? context.colors.neonBlue
                            : !isOnUsersTab
                            ? Colors.white
                            : null,
                        borderRadius: 8,
                        padding: AppPadding.symmetric(10, 6),
                        bgColor: !isOnUsersTab ? Colors.transparent : null,
                        borderColor: !isOnUsersTab ? Colors.white : null,
                      );
                    }
                    return const SizedBox.shrink();
                  },

                  error: error,
                  loading: loader,
                ),
              ],
            ),
          ),
        ),
        if (isOnUsersTab)
          Padding(
            padding: AppPadding.symmetric(4, 8),
            child: const Divider(thickness: 0.5),
          ),
      ],
    );
  }
}
