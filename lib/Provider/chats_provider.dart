import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/debug_print.dart';

class LongPressedNotifier extends StateNotifier<bool> {
  LongPressedNotifier() : super(false);

  void start() {
    state = true;
  }

  void stop() {
    state = false;
  }
}

class ChatSelectionNotifier extends StateNotifier<List> {
  ChatSelectionNotifier() : super([]);

  void addChat(int index) {
    state = [...state, index];
  }

  void removeChat(int index) {
    state = state.where((i) => i != index).toList();
  }

  void clear() {
    state = [];
  }
}

class ChatCopyNotifier extends StateNotifier<List> {
  ChatCopyNotifier() : super([]);
  void addText(String text) {
    state = [...state, text];
  }

  void removeText(String text) {
    state = state.where((i) => i != text).toList();
  }

  void clear() {
    state = [];
  }
}

final longPressedProvider = StateNotifierProvider<LongPressedNotifier, bool>(
    (ref) => LongPressedNotifier());

final chatSelectionProvider =
    StateNotifierProvider<ChatSelectionNotifier, List>(
        (ref) => ChatSelectionNotifier());

final chatCopyProvider =
    StateNotifierProvider<ChatCopyNotifier, List>((ref) => ChatCopyNotifier());
