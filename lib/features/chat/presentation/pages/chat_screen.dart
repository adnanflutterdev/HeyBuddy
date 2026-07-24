import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/encryption.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/chat/data/models/chat_model.dart';
import 'package:hey_buddy/features/chat/data/models/seen_model.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/domain/entity/seen.dart';
import 'package:hey_buddy/features/chat/domain/usecase/send_chat_usecase.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_provider.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/build_chats.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.fData,
    required this.friend,
    required this.conversation,
  });
  final UserData fData;
  final Friend friend;
  final Conversation? conversation;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  void sendChat() async {
    final uid = ref.read(uidProvider);
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
    );

    SendChatParams params = SendChatParams(
      myUid: uid,
      fUid: widget.friend.friendId,
      chatsDocId: widget.friend.chatsDocId,
      chat: chat,
      chatDocExisits: widget.conversation != null,
    );
    Result result = await ref.read(chatProvider.notifier).sendChat(params);

    if (!result.success && mounted) {
      showMessenger(context, result: result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 70,
        leadingWidth: 40,
        titleWidget: _buildAppBarContent(),
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
          children: [_buildChats(), _buildTextField()],
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Row(
      spacing: 10,
      children: [
        ProfileImage(imageUrl: widget.fData.profile.profileImage),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              Text(
                widget.fData.details.name,
                style: context.style.h3.copyWith(
                  color: context.colors.neonBlue,
                ),
              ),
              Text(
                '● Online',
                style: context.style.bs2.copyWith(
                  color: context.colors.neonGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChats() {
    final uid = ref.watch(uidProvider);
    final chatsRef = ref.watch(
      getChatStreamProvider((uid, widget.friend.chatsDocId)),
    );
    return chatsRef.when(
      data: (chats) {
        return BuildChats(chats: chats, friend: widget.friend);
      },
      error: error,
      loading: loader,
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: AppPadding.symmetric(8, 4),
      child: Row(
        spacing: 4,
        children: [
          AppMaterialButton(
            icon: Icons.add,
            isTransparent: true,
            iconSize: 25,
            padding: AppPadding.p4,
            onPressed: () {},
          ),
          Expanded(
            child: AppTextField(
              minLines: 1,
              maxLines: 4,
              controller: messageController,
            ),
          ),
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
                  onPressed: chatRef.isLoading ? null : sendChat,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
