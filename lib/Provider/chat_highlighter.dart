import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatHighlighterNotifier extends StateNotifier<int> {
  ChatHighlighterNotifier() : super(-1);

  void addChat(int index) {
    state = index;
  }

  void clear() {
    state = -1;
  }
}

final chatHighlighterProvider =
    StateNotifierProvider<ChatHighlighterNotifier,int>((ref) => ChatHighlighterNotifier());
