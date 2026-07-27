import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

class ChatHolder {
  final Chat? prev;
  final Chat current;
  final int chatIndex;
  final int? unSeenIndex;

  ChatHolder({
    required this.prev,
    required this.current,
    required this.chatIndex,
    required this.unSeenIndex,
  });
}
