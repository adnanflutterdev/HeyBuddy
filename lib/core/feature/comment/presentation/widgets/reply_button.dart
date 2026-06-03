import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/open_comment_sheet.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_reply_provider.dart';
import 'package:hey_buddy/core/feature/comment/presentation/screens/comment_reply_sheet.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';

class ReplyButton extends StatelessWidget {
  const ReplyButton({super.key, required this.replyTo, required this.replyRef});
  final CommentReplyTo replyTo;
  final CollectionReference replyRef;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppMeterialButton(
          text: 'Reply',
          onPressed: () => openCommentSheet(
            context: context,
            sheet: CommentsReplySheet(replyTo),
          ),
          style: context.style.b3.copyWith(color: context.colors.neonBlue),
        ),
        Consumer(
          builder: (context, ref, _) {
            final commentReplyStream = ref.watch(getCommentStream(replyRef));
            return commentReplyStream.when(
              data: (replies) {
                if (replies.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Text('(${replies.length})', style: context.style.bs3);
              },
              error: (error, stackTrace) =>
                  Text('(0)', style: context.style.bs3),
              loading: () => Text('(0)', style: context.style.bs3),
            );
          },
        ),
      ],
    );
  }
}
