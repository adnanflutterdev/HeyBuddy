import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/debug_print.dart';

class ChatReplyNotifier extends StateNotifier<Map> {
  ChatReplyNotifier() : super({});

  void addTextReply(
      {required String docId,
      required String name,
      required String message,
      required bool isMine}) {
    state = {
      'docId': docId,
      'name': name,
      'type': 'text',
      'isMine': isMine,
      'message': message,
    };
  }

  void addImageReply(
      {required String docId,
      required String name,
      required String imageUrl,
      required String message,
      required bool isMine}) {
    state = {
      'docId': docId,
      'name': name,
      'type': 'image',
      'isMine': isMine,
      'message': message,
      'imageUrl': imageUrl,
    };
  }

  void clear() {
    state = {};
  }
}

final chatReplyProvider =
    StateNotifierProvider<ChatReplyNotifier, Map>((ref) => ChatReplyNotifier());
