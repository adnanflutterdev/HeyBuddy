import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat_holder.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BuildChats extends StatefulWidget {
  const BuildChats({
    super.key,
    required this.chats,
    required this.friend,
    required this.fData,
    required this.conversation,
    required this.scrollController,
  });
  final List<Chat> chats;
  final Friend friend;
  final UserData fData;
  final Conversation? conversation;
  final ItemScrollController scrollController;

  @override
  State<BuildChats> createState() => _BuildChatsState();
}

class _BuildChatsState extends State<BuildChats> {
  late List<Chat> chats;

  @override
  void initState() {
    super.initState();
    chats = widget.chats;
  }

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Center(
        child: Text('No Chats Yet\nStart chatting with your friend'),
      );
    }
    return Expanded(
      child: ScrollablePositionedList.separated(
        itemScrollController: widget.scrollController,
        initialScrollIndex: widget.conversation?.lastIndex ?? 0,
        padding: AppPadding.symmetric(10, 15),
        itemBuilder: (context, index) {
          final chat = ChatHolder(
            prev: index > 0 ? chats[index - 1] : null,
            current: chats[index],
          );
          return GestureDetector(
            onTap: () {
              if (chats[index].replyTo != null) {
                int scrollToIndex = chats.indexWhere(
                  (c) => c.chatId == chats[index].replyTo!.chatId,
                );
                widget.scrollController.jumpTo(index: scrollToIndex);
              }
            },
            child: ChatBubble(
              chat: chat,
              friend: widget.friend,
              fData: widget.fData,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return AppSpacing.h12;
        },
        itemCount: chats.length,
      ),
    );
  }
}
