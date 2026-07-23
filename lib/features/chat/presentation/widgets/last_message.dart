import 'package:flutter/material.dart';
import 'package:hey_buddy/core/utils/encryption.dart';
import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

class LastMessage extends StatelessWidget {
  const LastMessage({super.key, required this.lastChat,required this.chatsDocId});
  final Chat lastChat;
  final String chatsDocId;

  @override
  Widget build(BuildContext context) {
    String message = Encryption.decrypt(
      encryptionKey: chatsDocId,
      encryptionValue: lastChat.timestamps.createdAt.toIso8601String(),
      message: lastChat.message,
    );

    return Text(message);
  }
}
