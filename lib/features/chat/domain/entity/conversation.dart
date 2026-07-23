import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

abstract class Conversation {
  final String id;
  final Chat? lastChat;
  final DateTime? updatedAt;
  final bool? isFriendActive;
  final String fUid;
  final int? lastIndex;

  Conversation({
    required this.id,
    required this.fUid,
    this.lastChat,
    this.updatedAt,
    this.lastIndex,
    this.isFriendActive,
  });
}
