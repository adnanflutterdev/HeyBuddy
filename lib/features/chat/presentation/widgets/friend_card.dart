import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/presentation/pages/chat_screen.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/last_message.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class FriendCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final lastChat = conversation?.lastChat;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            AppNavigator.push(
              ChatScreen(
                fData: fData,
                friend: friend,
                conversation: conversation,
              ),
            );
          },
          child: ColoredBox(
            color: Colors.transparent,
            child: Row(
              children: [
                ProfileImage(imageUrl: fData.profile.profileImage),
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
                            TextSpan(text: fData.details.username),
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
              ],
            ),
          ),
        ),
        AppSpacing.h8,
        const Divider(thickness: 0.5),
        AppSpacing.h8,
      ],
    );
  }
}
