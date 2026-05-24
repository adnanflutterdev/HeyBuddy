import 'package:flutter_riverpod/legacy.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class CommentReplyTo {
  final String id;
  final Comment comment;
  final UserData user;

  CommentReplyTo({required this.id, required this.comment, required this.user});
}

class CommentReplyNotifer extends StateNotifier<CommentReplyTo?> {
  CommentReplyNotifer() : super(null);

  void startReply(CommentReplyTo replyTo) {
    state = replyTo;
  }

  void stopReply() {
    state = null;
  }
}

final commentReplyToProvider =
    StateNotifierProvider.autoDispose<CommentReplyNotifer, CommentReplyTo?>(
      (ref) => CommentReplyNotifer(),
    );
