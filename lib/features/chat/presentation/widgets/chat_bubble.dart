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

class _ChatBubbleState extends ConsumerState<ChatBubble> {
  //
  late List<String> cDateTime;
  late List<String>? pDateTime;
  late String message;
  late String myUid;
  late bool isMine;

  @override
  void initState() {
    super.initState();

    cDateTime = DatetimeFormat.format(
      widget.chat.current.timestamps.createdAt,
    ).split(', ');

    pDateTime = widget.chat.prev != null
        ? DatetimeFormat.format(
            widget.chat.prev!.timestamps.createdAt,
          ).split(', ')
        : null;

    message = Encryption.decrypt(
      encryptionKey: widget.friend.chatsDocId,
      encryptionValue: widget.chat.current.timestamps.createdAt
          .toIso8601String(),
      message: widget.chat.current.message,
    );

    myUid = ref.read(uidProvider);
    isMine = myUid == widget.chat.current.uid;
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (pDateTime == null || pDateTime!.first != cDateTime.first) ...[
          Container(
            decoration: BoxDecoration(
              color: context.colors.appbar,
              borderRadius: BorderRadius.circular(4),
            ),
            padding: AppPadding.symmetric(8, 4),
            child: Text(cDateTime.first, style: context.style.bs2),
          ),
          AppSpacing.h8,
        ],
        // Chat Bubble Here
        Container(
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
                  constraints: BoxConstraints(
                    maxWidth: (4 / 5) * context.width,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMine
                          ? context.colors.myBubble
                          : context.colors.otherBubble,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: AppPadding.symmetric(10, 4),
                    child: _buildChatContent(),
                  ),
                ),
                if (!isMine) _buildReplyButton(),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildChatContent() {
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
                  color: context.colors.appbar,
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
        _buildTextMessage(),
        Text(
          cDateTime.last,
          style: context.style.bs3.copyWith(
            color: context.colors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildTextMessage() {
    return CollapsibleText(
      text: message,
      maxLength: 200,
      togglerStyle: context.style.bs1,
    );
  }
}
