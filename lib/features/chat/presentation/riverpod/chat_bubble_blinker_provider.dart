import 'package:flutter_riverpod/legacy.dart';

class ChatBubbleBlinkerNotifier extends StateNotifier<String?> {
  ChatBubbleBlinkerNotifier() : super(null);

  void startBlink(String chatId) {
    state = chatId;
  }

  void stopBlink() {
    state = null;
  }
}

final chatBubbleBlinkerProvider =
    StateNotifierProvider<ChatBubbleBlinkerNotifier, String?>(
      (ref) => ChatBubbleBlinkerNotifier(),
    );
