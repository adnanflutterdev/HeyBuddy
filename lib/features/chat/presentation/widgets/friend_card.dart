import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/datetime_format.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/presentation/pages/chat_screen.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_provider.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/last_message.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class FriendCard extends ConsumerWidget {
  const FriendCard({
    super.key,
    required this.fData,
    this.conversation,
    required this.friend,
  });
  final UserData fData;
  final Friend friend;
  final Conversation? conversation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(uidProvider);
    final lastChatRef = ref.watch(
      getLastChatProvider((uid, friend.chatsDocId)),
    );

    return lastChatRef.when(
      data: (lastChat) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                AppNavigator.push(ChatScreen(friend: friend));
              },
              child: ColoredBox(
                color: Colors.transparent,
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: [
                          ProfileImage(imageUrl: fData.profile.profileImage),
                          if (fData.account.isOnline)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: .circle,
                                  color: context.colors.neonGreen,
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.colors.shadow,
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AppSpacing.w12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '@',
                                  style: context.style.b1.copyWith(
                                    color: context.colors.neonBlue,
                                  ),
                                ),
                                TextSpan(
                                  text: fData.details.username,
                                  style: context.style.b2.copyWith(
                                    color: context.colors.primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (lastChat == null)
                            Text(fData.details.name)
                          else
                            LastMessage(
                              lastChat: lastChat,
                              chatsDocId: friend.chatsDocId,
                            ),
                        ],
                      ),
                    ),
                    if (lastChat != null)
                      Text(
                        DatetimeFormat.format(lastChat.timestamps.createdAt),
                      ),
                  ],
                ),
              ),
            ),
            AppSpacing.h8,
            const Divider(thickness: 0.5),
            AppSpacing.h8,
          ],
        );
      },
      error: error,
      loading: loader,
    );
  }
}
