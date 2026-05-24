import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_comment_reply_usecase.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_reply_provider.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:uuid/uuid.dart';

class CommentsReplySheet extends StatefulWidget {
  const CommentsReplySheet(this.replyTo, {super.key});
  final CommentReplyTo replyTo;
  @override
  State<CommentsReplySheet> createState() => _CommentsReplySheetState();
}

class _CommentsReplySheetState extends State<CommentsReplySheet> {
  double _height = 600;
  final TextEditingController _controller = .new();

  Future<void> addCommentReply(WidgetRef ref) async {
    CommentReplyTo replyTo = widget.replyTo;

    Comment commentReply = CommentModel(
      id: const Uuid().v4(),
      userId: ref.read(uidProvider),
      content: CommentContentModel(text: _controller.text),
      timestamps: TimestampsModel(createdAt: DateTime.now()),
    );

    AddCommentReplyParams params = AddCommentReplyParams(
      id: replyTo.id,
      commentId: replyTo.comment.id,
      commentReply: commentReply,
    );

    Result result = await ref
        .read(commentProvider.notifier)
        .addCommentReply(params);

    if (!result.success) {
      if (mounted) {
        showMessenger(context, result: result);
      }
    } else {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: context.width,
      decoration: BoxDecoration(
        color: context.colors.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: .min,
          children: [
            _buildDragger(), _buildCommentField(),
            //  _buildComments()
          ],
        ),
      ),
    );
  }

  Widget _buildDragger() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        double newHeight = _height - (details.primaryDelta ?? 0);
        if (newHeight < 300) {
          AppNavigator.pop();
        }
        setState(() {
          _height = newHeight.clamp(300, (9 / 10) * context.height);
        });
      },
      child: Container(
        color: Colors.transparent,
        width: context.width,
        height: 40,
        child: Align(
          alignment: .center,
          child: Container(
            width: 50,
            height: 8,
            decoration: BoxDecoration(
              color: context.colors.secondaryText,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentField() {
    return Padding(
      padding: AppPadding.p16,
      child: Consumer(
        builder: (context, ref, _) {
          final addCommentRef = ref.watch(commentProvider);
          if (addCommentRef.isLoading) {
            return AppTextField(
              isSuffixIconLoading: true,
              controller: _controller,
              isReadOnly: true,
            );
          }
          return AppTextField(
            hintText: 'Write your comment reply',
            suffixIcon: Icons.send,
            controller: _controller,
            unfocousOnTapOutside: true,
            onSuffixIconTapped: () => addCommentReply(ref),
          );
        },
      ),
    );
  }

  //   Widget _buildComments() {
  //     return Expanded(
  //       child: Padding(
  //         padding: AppPadding.p8,
  //         child: Consumer(
  //           builder: (context, ref, _) {
  //             final commentStream = ref.watch(getCommentStream(widget.id));
  //             return commentStream.when(
  //               data: (comments) {
  //                 return ListView.separated(
  //                   itemBuilder: (context, index) {
  //                     return CommentBubble(
  //                       id: widget.id,
  //                       comments: (
  //                         prev: index == 0 ? null : comments[index - 1],
  //                         current: comments[index],
  //                       ),
  //                     );
  //                   },
  //                   separatorBuilder: (context, index) {
  //                     return AppSpacing.h8;
  //                   },
  //                   itemCount: comments.length,
  //                 );
  //               },
  //               error: (error, stackTrace) {
  //                 return const SizedBox.expand();
  //               },
  //               loading: () {
  //                 return const Center(
  //                   child: SizedBox(
  //                     width: 30,
  //                     height: 30,
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         ),
  //       ),
  //     );
  //   }
}
