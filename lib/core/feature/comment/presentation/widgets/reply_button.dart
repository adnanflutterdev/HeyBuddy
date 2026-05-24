import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/open_comment_sheet.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_reply_provider.dart';
import 'package:hey_buddy/core/feature/comment/presentation/screens/comment_reply_sheet.dart';
import 'package:hey_buddy/core/widgets/material_text_button.dart';

class ReplyButton extends StatelessWidget {
  const ReplyButton(this.replyTo, {super.key});
  final CommentReplyTo replyTo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialTextButton(
          text: 'Reply',
          onPressed: () => openCommentSheet(
            context: context,
            sheet: CommentsReplySheet(replyTo),
          ),
          style: context.style.b3.copyWith(color: context.colors.neonBlue),
        ),
        Text('(0)', style: context.style.bs3),
      ],
    );
  }
}
