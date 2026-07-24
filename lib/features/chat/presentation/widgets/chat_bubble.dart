import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/utils/datetime_format.dart';
import 'package:hey_buddy/core/utils/encryption.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat_holder.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.chat, required this.friend});
  final ChatHolder chat;
  final Friend friend;

  @override
  Widget build(BuildContext context) {
    List<String> cDateTime = DatetimeFormat.format(
      chat.current.timestamps.createdAt,
    ).split(', ');
    List<String>? pDateTime = chat.prev != null
        ? DatetimeFormat.format(chat.prev!.timestamps.createdAt).split(', ')
        : null;
    String message = Encryption.decrypt(
      encryptionKey: friend.chatsDocId,
      encryptionValue: chat.current.timestamps.createdAt.toIso8601String(),
      message: chat.current.message,
    );
    return Column(
      children: [
        if (pDateTime == null || pDateTime.first != cDateTime.first) ...[
          Container(
            decoration: BoxDecoration(
              color: context.colors.appbar,
              borderRadius: BorderRadius.circular(4),
            ),

            padding: AppPadding.symmetric(8, 4),
            child: Text(cDateTime.first),
          ),
          AppSpacing.h8,
        ],
        Text(message),
      ],
    );
  }
}
