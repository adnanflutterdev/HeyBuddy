import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/outlined_border.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/encryption.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/data/models/seen_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/entity/reply_to.dart';
import 'package:hey_buddy/features/chat/domain/entity/seen.dart';
import 'package:hey_buddy/features/chat/domain/usecase/send_chat_usecase.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_provider.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_reply_provider.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/build_chats.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.friend});
  final Friend friend;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ItemScrollController scrollController = ItemScrollController();
  final TextEditingController messageController = TextEditingController();
  final WidgetStatesController statesController = WidgetStatesController();

  void sendChat(Conversation? conversation) async {
    final uid = ref.read(uidProvider);
    final replyTo = ref.read(chatReplyProvider);
    TimestampsModel timestamps = TimestampsModel(createdAt: DateTime.now());
    Seen seen = SeenModel(isSeen: false);
    String message = Encryption.encrypt(
      encryptionKey: widget.friend.chatsDocId,
      encryptionValue: timestamps.createdAt.toIso8601String(),
      message: messageController.text.trim(),
    );
    messageController.clear();
    ChatModel chat = ChatModel(
      uid: uid,
      message: message,
      timestamps: timestamps,
      type: MessageType.text,
      seen: seen,
      isEdited: false,
      media: null,
      chatId: const Uuid().v4(),
      replyTo: replyTo,
    );

    SendChatParams params = SendChatParams(
      myUid: uid,
      fUid: widget.friend.friendId,
      chatsDocId: widget.friend.chatsDocId,
      chat: chat,
      chatDocExisits: conversation != null,
    );
    if (mounted) {
      ref.read(chatReplyProvider.notifier).stopReply();
    }

    Result result = await ref.read(chatProvider.notifier).sendChat(params);

    // scrollController.scrollTo(
    //   index: (conversation?.lastIndex ?? -1) + 1,
    //   duration: const Duration(milliseconds: 500),
    // );
    if (!result.success && mounted) {
      showMessenger(context, result: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(uidProvider);
    final conversationRef = ref.watch(
      getConversationProvider((uid, widget.friend.chatsDocId)),
    );

    final fDataRef = ref.watch(userDataStreamProvider(widget.friend.friendId));
    return fDataRef.when(
      data: (fData) {
        if (fData == null) {
          return const Scaffold(
            body: Center(child: Text('Failed to retrive your friend\'s data')),
          );
        }
        return conversationRef.when(
          data: (conversation) {
            return Scaffold(
              appBar: CustomAppBar(
                height: 70,
                leadingWidth: 40,
                titleWidget: _buildAppBarContent(conversation, fData),
                actions: [
                  AppMaterialButton(
                    iconSize: 25,
                    isTransparent: true,
                    icon: Icons.more_vert,
                    padding: AppPadding.p4,
                    onPressed: () {},
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  spacing: 10,
                  children: [
                    _buildChats(conversation, fData),
                    _buildTextField(conversation, fData),
                  ],
                ),
              ),
            );
          },
          error: error,
          loading: loader,
        );
      },
      error: error,
      loading: loader,
    );
  }

  Widget _buildAppBarContent(Conversation? conversation, UserData fData) {
    bool isOnline = fData.account.isOnline;
    DateTime? lastSeen = fData.account.lastActive;
    String onlineStatusMessage = isOnline
        ? '● Online'
        : lastSeen != null
        ? DateFormat.yMEd().format(lastSeen)
        : 'Offline';

    return Row(
      spacing: 10,
      children: [
        ProfileImage(imageUrl: fData.profile.profileImage),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              Text(
                fData.details.name,
                style: context.style.h3.copyWith(
                  color: context.colors.neonBlue,
                ),
              ),
              Text(
                onlineStatusMessage,
                style: context.style.bs2.copyWith(
                  color: isOnline
                      ? context.colors.neonGreen
                      : context.colors.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChats(Conversation? conversation, UserData fData) {
    final uid = ref.watch(uidProvider);
    final chatsRef = ref.watch(
      getChatsProvider((uid, widget.friend.chatsDocId)),
    );
    return chatsRef.when(
      data: (chats) {
        return BuildChats(
          chats: chats,
          fData: fData,
          friend: widget.friend,
          conversation: conversation,
          scrollController: scrollController,
        );
      },
      error: error,
      loading: loader,
    );
  }

  Widget _buildTextField(Conversation? conversation, UserData fData) {
    final replyTo = ref.watch(chatReplyProvider);
    return Padding(
      padding: AppPadding.symmetric(8, 4),
      child: Row(
        crossAxisAlignment: .end,
        spacing: 4,
        children: [
          _buildMessageField(replyTo, fData),
          ValueListenableBuilder(
            valueListenable: messageController,
            builder: (context, message, _) {
              if (message.text.trim().isNotEmpty) {
                final chatRef = ref.watch(chatProvider);
                return AppMaterialButton(
                  icon: Icons.send,
                  isTransparent: true,
                  iconSize: 25,
                  padding: AppPadding.p8,
                  onPressed: chatRef.isLoading
                      ? null
                      : () => sendChat(conversation),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageField(ReplyTo? replyTo, UserData fData) {
    final uid = ref.watch(uidProvider);
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: statesController,
        builder: (context, state, child) {
          bool isFocused = state.contains(WidgetState.focused);
          String message = replyTo != null
              ? Encryption.decrypt(
                  encryptionKey: widget.friend.chatsDocId,
                  encryptionValue: replyTo.timestamps.createdAt
                      .toIso8601String(),
                  message: replyTo.message,
                )
              : '';
          return Container(
            decoration: BoxDecoration(
              color: context.colors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: isFocused ? 0.8 : 0.5,
                color: isFocused
                    ? context.colors.neonBlue
                    : context.colors.primaryText,
              ),
            ),
            padding: AppPadding.p4,
            clipBehavior: .antiAliasWithSaveLayer,
            child: Column(
              children: [
                if (replyTo != null)
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.bg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: AppPadding.symmetric(10, 6),

                    child: Row(
                      children: [
                        const Icon(Icons.reply, size: 20),
                        AppSpacing.w8,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              if (replyTo.uid == uid)
                                Text(
                                  'You',
                                  style: context.style.b2.copyWith(
                                    color: context.colors.neonBlue,
                                  ),
                                )
                              else
                                Text(
                                  fData.details.username,
                                  style: context.style.b2.copyWith(
                                    color: context.colors.neonGreen,
                                  ),
                                ),
                              Text(
                                message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        AppMaterialButton(
                          icon: Icons.close,
                          onPressed: () {
                            ref.read(chatReplyProvider.notifier).stopReply();
                          },
                          isTransparent: true,
                          iconSize: 20,
                        ),
                      ],
                    ),
                  ),
                TextField(
                  controller: messageController,
                  statesController: statesController,
                  style: context.style.b2,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: AppPadding.symmetric(2, 6),
                    hintText: 'Write message here...',
                    fillColor: context.colors.card,
                    enabledBorder: none(),
                    focusedBorder: none(),
                    suffixIcon: AppMaterialButton(
                      icon: Icons.attach_file,
                      isTransparent: true,
                      iconSize: 22,
                      padding: AppPadding.p4,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
