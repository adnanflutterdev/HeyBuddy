import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

abstract class Conversation {
  final Chat? lastChat;
  final DateTime? updatedAt;
  final bool? isFriendActive;
  final int? lastIndex;

  Conversation({
    this.lastChat,
    this.updatedAt,
    this.isFriendActive,
    this.lastIndex,
  });
}
