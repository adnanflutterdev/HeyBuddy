import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_reply_provider.dart';
import 'package:hey_buddy/core/feature/comment/presentation/widgets/reaction_button.dart';
import 'package:hey_buddy/core/feature/comment/presentation/widgets/reply_button.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/users_provider.dart';
import 'package:intl/intl.dart';

class CommentBubble extends StatelessWidget {
  const CommentBubble({
    super.key,
    required this.id,
    required this.comments,
    required this.commentsRef,

    this.allowReply = true,
  });
  final String id;
  final CollectionReference commentsRef;
  final ({Comment? prev, Comment current}) comments;

  final bool allowReply;

  @override
  Widget build(BuildContext context) {
    String? date;

    final Comment comment = comments.current;

    if (comments.prev == null) {
      date = DateFormat.yMMMEd().format(comment.timestamps.createdAt);
    } else {
      String prevDate = DateFormat.yMMMEd().format(
        comments.prev!.timestamps.createdAt,
      );
      String currentDate = DateFormat.yMMMEd().format(
        comment.timestamps.createdAt,
      );
      if (prevDate != currentDate) {
        date = currentDate;
      }
    }

    return Column(
      mainAxisSize: .min,
      children: [
        if (date != null) _buildDate(context: context, date: date),
        _buildComment(context: context, comment: comment),
      ],
    );
  }

  Widget _buildDate({required BuildContext context, required String date}) {
    return Padding(
      padding: AppPadding.v12,
      child: Container(
        padding: AppPadding.symmetric(8, 4),
        decoration: BoxDecoration(
          color: context.colors.container,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(date),
      ),
    );
  }

  Widget _buildComment({
    required BuildContext context,
    required Comment comment,
  }) {
    final GetColor colors = context.colors;
    return Consumer(
      builder: (context, ref, child) {
        //
        final String myUid = ref.watch(uidProvider);
        final bool isMine = comments.current.userId == myUid;
        final userRef = ref.watch(usersDataProvider(comment.userId));

        final constraints = BoxConstraints(
          maxWidth: ((8.5 / 10) * context.width) - (isMine ? 0 : 50),
        );

        return userRef.when(
          data: (user) {
            return Row(
              crossAxisAlignment: isMine ? .end : .start,
              children: [
                if (isMine)
                  const Spacer()
                else
                  ..._buildProfileImage(user.profile.profileImage),
                Container(
                  alignment: isMine ? .centerRight : .centerLeft,
                  child: ConstrainedBox(
                    constraints: constraints,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        _buildCommentBubble(
                          context: context,
                          colors: colors,
                          isMine: isMine,
                          comment: comment,
                          userName: isMine ? 'You' : user.details.name,
                        ),
                        ..._buildActions(
                          CommentReplyTo(id: id, comment: comment, user: user),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          error: error,
          loading: () => Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: colors.container, shape: .circle),
          ),
        );
      },
    );
  }

  List<Widget> _buildProfileImage(String? profileImage) {
    return [ProfileImage(imageUrl: profileImage), AppSpacing.w8];
  }

  Widget _buildCommentBubble({
    required BuildContext context,
    required GetColor colors,
    required bool isMine,
    required Comment comment,
    required String userName,
  }) {
    return Container(
      padding: AppPadding.symmetric(12, 6),
      decoration: BoxDecoration(
        color: isMine ? colors.myBubble : colors.otherBubble,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isMine ? 12 : 0),
          bottomRight: Radius.circular(isMine ? 0 : 12),
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(userName, style: context.style.b1),
          AppSpacing.h4,
          Column(
            crossAxisAlignment: .end,
            children: [
              Text(comment.content.text!),
              Row(
                mainAxisSize: .min,
                mainAxisAlignment: .end,
                children: [
                  Text(
                    DateFormat('hh:mm a').format(comment.timestamps.createdAt),
                    style: context.style.bs3.copyWith(
                      fontWeight: .bold,
                      color: colors.primaryText.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(CommentReplyTo replyTo) {
    final commentRef = commentsRef.doc(replyTo.comment.id);
    return [
      AppSpacing.h4,
      Row(
        mainAxisSize: .min,
        children: [
          ReactionButton(reactionsRef: commentRef.collection('reactions')),
          if (allowReply) ...[
            AppSpacing.w8,
            ReplyButton(
              replyTo: replyTo,
              repliesRef: commentRef.collection('replies'),
            ),
          ],
        ],
      ),
      AppSpacing.h4,
    ];
  }
}
