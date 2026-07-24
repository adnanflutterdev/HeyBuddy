import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat_holder.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';

class BuildChats extends StatelessWidget {
  const BuildChats({super.key, required this.chats, required this.friend});
  final List<Chat> chats;
  final Friend friend;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Center(
        child: Text('No Chats Yet\nStart chatting with your friend'),
      );
    }
    return Expanded(
      child: ListView.separated(
        padding: AppPadding.symmetric(10, 15),
        itemBuilder: (context, index) {
          final chat = ChatHolder(
            prev: index > 0 ? chats[index - 1] : null,
            current: chats[index],
          );
          return ChatBubble(chat: chat, friend: friend);
        },
        separatorBuilder: (context, index) {
          return AppSpacing.h12;
        },
        itemCount: chats.length,
      ),
    );
  }
}
