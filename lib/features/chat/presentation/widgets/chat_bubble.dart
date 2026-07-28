import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/datetime_format.dart';
import 'package:hey_buddy/core/utils/encryption.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/collapsible_text.dart';
import 'package:hey_buddy/features/chat/data/models/reply_to_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat_holder.dart';
import 'package:hey_buddy/features/chat/domain/entity/reply_to.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_bubble_blinker_provider.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_reply_provider.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class ChatBubble extends ConsumerStatefulWidget {
  const ChatBubble({
    super.key,
    required this.chat,
    required this.friend,
    required this.fData,
  });
  final ChatHolder chat;
  final Friend friend;
  final UserData fData;

  @override
  ConsumerState<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends ConsumerState<ChatBubble>
    with TickerProviderStateMixin {
  //
  late bool isMessageUnseen;
  late AnimationController _newMessageController;
  late Animation<double> _newMessageAnimation;
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  bool hideNewMessageIndicator = false;

  @override
  void initState() {
    super.initState();

    isMessageUnseen = widget.chat.chatIndex == widget.chat.unSeenIndex;

    initializeAnimations();

    if (isMessageUnseen) {
      _newMessageController.repeat();

      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          _newMessageController.stop();
        }
      });

      Timer(const Duration(seconds: 6), () {
        if (mounted) {
          setState(() {
            hideNewMessageIndicator = true;
          });
        }
      });
    }
  }

  void initializeAnimations() {
    _newMessageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _newMessageAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_newMessageController);

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _blinkAnimation = Tween<double>(begin: 1, end: 0).animate(_blinkController);
  }

  void startReply() {
    final replyToNotifier = ref.read(chatReplyProvider.notifier);
    final current = widget.chat.current;
    ReplyTo replyTo = ReplyToModel(
      chatId: current.chatId,
      uid: current.uid,
      timestamps: current.timestamps,
      media: current.media?.first,
      message: current.message,
      type: current.type,
    );

    replyToNotifier.startReply(replyTo);
  }

  @override
  void dispose() {
    _newMessageController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatBlinkerProvider = ref.watch(chatBubbleBlinkerProvider);
    bool canBlink = chatBlinkerProvider == widget.chat.current.chatId;

    if (canBlink) {
      _blinkController.repeat();

      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          ref.read(chatBubbleBlinkerProvider.notifier).stopBlink();
        }
      });
    }
    List<String> cDateTime = DatetimeFormat.format(
      widget.chat.current.timestamps.createdAt,
    ).split(', ');
    List<String>? pDateTime = widget.chat.prev != null
        ? DatetimeFormat.format(
            widget.chat.prev!.timestamps.createdAt,
          ).split(', ')
        : null;

    return Column(
      children: [
        //
        // Date section
        if (pDateTime == null || pDateTime.first != cDateTime.first) ...[
          AppSpacing.h12,
          Container(
            decoration: BoxDecoration(
              color: context.colors.appbar,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(blurRadius: 3, color: context.colors.shadow),
              ],
            ),
            padding: AppPadding.symmetric(8, 4),
            child: Text(cDateTime.first, style: context.style.bs2),
          ),
          AppSpacing.h12,
        ],
        //
        // New message indicator
        if (isMessageUnseen && !hideNewMessageIndicator) ...[
          FadeTransition(
            opacity: _newMessageAnimation,
            child: Container(
              color: context.colors.myBubble,
              padding: AppPadding.v4,
              child: const Center(child: Text('new message')),
            ),
          ),
          AppSpacing.h8,
        ],

        //
        // Chat Bubble Here
        if (canBlink)
          FadeTransition(
            opacity: _blinkAnimation,
            child: _buildBubble(cDateTime, context.colors.card),
          )
        else
          _buildBubble(cDateTime),
      ],
    );
  }

  Widget _buildBubble(List<String> cDateTime, [Color? color]) {
    String message = Encryption.decrypt(
      encryptionKey: widget.friend.chatsDocId,
      encryptionValue: widget.chat.current.timestamps.createdAt
          .toIso8601String(),
      message: widget.chat.current.message,
    );
    String myUid = ref.read(uidProvider);
    bool isMine = myUid == widget.chat.current.uid;
    return Container(
      color: color,
      alignment: isMine ? .centerRight : .centerLeft,
      padding: AppPadding.v4,
      child: Dismissible(
        key: Key(widget.chat.current.chatId),
        direction: .startToEnd,
        dismissThresholds: {DismissDirection.startToEnd: 0.2},
        onDismissed: (direction) {},
        confirmDismiss: (direction) async {
          startReply();
          return false;
        },
        child: Row(
          spacing: 4,
          crossAxisAlignment: .end,
          mainAxisAlignment: isMine ? .end : .start,
          children: [
            if (isMine) _buildReplyButton(),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: (4 / 5) * context.width),
              child: Container(
                decoration: BoxDecoration(
                  color: isMine
                      ? context.colors.myBubble
                      : context.colors.otherBubble,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: AppPadding.symmetric(8, 6),
                child: _buildChatContent(myUid, isMine, message, cDateTime),
              ),
            ),
            if (!isMine) _buildReplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyButton() {
    return AppMaterialButton(
      icon: Icons.reply,
      padding: AppPadding.p8,
      iconSize: 20,
      isTransparent: true,
      onPressed: startReply,
    );
  }

  Widget _buildChatContent(
    String myUid,
    bool isMine,
    String message,
    List<String> cDateTime,
  ) {
    ReplyTo? replyTo = widget.chat.current.replyTo;
    String replyMessage = replyTo != null
        ? Encryption.decrypt(
            encryptionKey: widget.friend.chatsDocId,
            encryptionValue: replyTo.timestamps.createdAt.toIso8601String(),
            message: replyTo.message,
          )
        : '';
    return Column(
      crossAxisAlignment: .end,
      children: [
        ...[
          if (replyTo != null)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: (7 / 10) * context.width),
              child: Container(
                decoration: BoxDecoration(
                  color: isMine
                      ? context.colors.appbar
                      : context.colors.neutral,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: AppPadding.symmetric(10, 6),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    if (replyTo.uid == myUid)
                      Text(
                        'You',
                        style: context.style.b2.copyWith(
                          color: context.colors.neonBlue,
                        ),
                      )
                    else
                      Text(
                        widget.fData.details.username,
                        style: context.style.b2.copyWith(
                          color: context.colors.neonGreen,
                        ),
                      ),
                    Text(replyMessage, maxLines: 2, overflow: .ellipsis),
                  ],
                ),
              ),
            ),
        ],
        AppSpacing.h4,
        _buildTextMessage(message),
        Text(
          cDateTime.last,
          style: context.style.bs3.copyWith(
            color: context.colors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildTextMessage(String message) {
    return CollapsibleText(
      text: message,
      maxLength: 200,
      togglerStyle: context.style.bs1,
    );
  }
}
