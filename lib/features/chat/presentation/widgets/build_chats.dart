import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/chat/data/models/online_status_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat_holder.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/usecase/update_online_status_usecase.dart';
import 'package:hey_buddy/features/chat/domain/usecase/update_last_index_usecase.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_bubble_blinker_provider.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_provider.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BuildChats extends ConsumerStatefulWidget {
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
  ConsumerState<BuildChats> createState() => _BuildChatsState();
}

class _BuildChatsState extends ConsumerState<BuildChats>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    updateConversation();
  }

  

  void updateConversation() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await updateOnlineStatus(true);
      await updateLastIndex();
    });
  }

  Future<void> updateLastIndex() async {
    final uid = ref.read(uidProvider);
    UpdateLastIndexUsecaseParams params = UpdateLastIndexUsecaseParams(
      uid: uid,
      chatDocId: widget.friend.chatsDocId,
      newIndex: widget.chats.length - 1,
    );
    if (mounted) {
      await ref.read(chatProvider.notifier).updateLastIndex(params);
    }
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    UpdateOnlineStatusUsecaseParams params = UpdateOnlineStatusUsecaseParams(
      fUid: widget.fData.uid,
      chatDocId: widget.friend.chatsDocId,
      onlineStatus: OnlineStatusModel(
        isOnline: isOnline,
        lastSeen: isOnline ? null : DateTime.now(),
      ),
    );
    if (mounted) {
      await ref.read(chatProvider.notifier).updateActiveStatus(params);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == .resumed) {
      await updateOnlineStatus(true);
    } else {
      await updateOnlineStatus(false);
      await updateLastIndex();
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = ref.watch(uidProvider);
    int? unSeenIndex = widget.chats.indexWhere(
      (chat) => !chat.seen.isSeen && chat.uid != uid,
    );
    if (unSeenIndex.isNegative) {
      unSeenIndex = null;
    }
    if (widget.chats.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No Chats Yet\nStart chatting with your friend',
            textAlign: .center,
          ),
        ),
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await updateLastIndex();
        await updateOnlineStatus(false);
        AppNavigator.pop();
      },
      child: Expanded(
        child: ScrollablePositionedList.separated(
          itemScrollController: widget.scrollController,
          initialScrollIndex: unSeenIndex ?? 0,
          padding: AppPadding.symmetric(10, 15),
          itemBuilder: (context, index) {
            final chat = ChatHolder(
              chatIndex: index,
              unSeenIndex: unSeenIndex,
              current: widget.chats[index],
              prev: index > 0 ? widget.chats[index - 1] : null,
            );
            return GestureDetector(
              onTap: () {
                if (widget.chats[index].replyTo != null) {
                  int scrollToIndex = widget.chats.indexWhere(
                    (c) => c.chatId == widget.chats[index].replyTo!.chatId,
                  );
                  widget.scrollController.jumpTo(
                    index: scrollToIndex,
                    alignment: 1,
                  );
                }
                if (mounted) {
                  ref
                      .read(chatBubbleBlinkerProvider.notifier)
                      .startBlink(widget.chats[index].replyTo!.chatId);
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
            return AppSpacing.h4;
          },
          itemCount: widget.chats.length,
        ),
      ),
    );
  }
}
