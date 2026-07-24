import 'package:hey_buddy/features/chat/domain/entity/chat.dart';

class ChatHolder {
  final Chat? prev;
  final Chat current;

  ChatHolder({required this.prev, required this.current});
}
