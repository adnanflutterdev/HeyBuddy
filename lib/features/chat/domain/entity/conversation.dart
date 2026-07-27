import 'package:hey_buddy/features/chat/domain/entity/chat.dart';
import 'package:hey_buddy/features/chat/domain/entity/online_status.dart';

abstract class Conversation {
  final String id;
  final Chat? lastChat;
  final DateTime? updatedAt;
  final OnlineStatus? onlineStatus;
  final String fUid;
  final int? lastIndex;

  Conversation({
    required this.id,
    required this.fUid,
    this.onlineStatus,
    this.lastChat,
    this.updatedAt,
    this.lastIndex,
  });
}
