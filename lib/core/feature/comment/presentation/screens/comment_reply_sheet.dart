import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/feature/comment/data/model/comment_model.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_reply_provider.dart';
import 'package:hey_buddy/core/feature/comment/presentation/widgets/comment_bubble.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/model/timestamps.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/feature/comment/domain/entity/comment.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:uuid/uuid.dart';

class CommentsReplySheet extends ConsumerStatefulWidget {
  const CommentsReplySheet(this.replyTo, {super.key});
  final CommentReplyTo replyTo;
  @override
  ConsumerState<CommentsReplySheet> createState() => _CommentsReplySheetState();
}

class _CommentsReplySheetState extends ConsumerState<CommentsReplySheet> {
  late double _height = (9 / 10) * context.height;
  final TextEditingController _controller = .new();
  late CollectionReference repliesRef;

  @override
  initState() {
    super.initState();

    repliesRef = ref
        .read(firebaseFirestoreProvider)
        .collection('post')
        .doc(widget.replyTo.id)
        .collection('comments')
        .doc(widget.replyTo.comment.id)
        .collection('replies');
  }

  Future<void> addCommentReply() async {
    Comment commentReply = CommentModel(
      id: const Uuid().v4(),
      userId: ref.read(uidProvider),
      content: CommentContentModel(text: _controller.text),
      timestamps: TimestampsModel(createdAt: DateTime.now()),
    );

    Result result = await ref
        .read(commentProvider.notifier)
        .addComment(repliesRef.doc(commentReply.id), commentReply);

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
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              _buildDragger(),
              _buildUserAndComment(),
              _buildComments(),
              _buildCommentField(),
            ],
          ),
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
        color: context.colors.container,
        width: context.width,
        height: 50,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: () {
                  AppNavigator.pop();
                },
                icon: const Icon(Icons.arrow_back, size: 30),
              ),
            ),
            Center(
              child: Container(
                width: 50,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.secondaryText,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAndComment() {
    final user = widget.replyTo.user;
    final uid = ref.watch(uidProvider);
    return Container(
      color: context.colors.container,
      padding: AppPadding.h8,
      child: Column(
        children: [
          Row(
            children: [
              ProfileImage(imageUrl: user.profile.profileImage, size: 40),
              AppSpacing.w12,
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ((8.5 / 10) * context.width) - 50,
                ),
                child: Container(
                  padding: AppPadding.symmetric(12, 6),
                  decoration: BoxDecoration(
                    color: uid == user.uid
                        ? context.colors.myBubble
                        : context.colors.otherBubble,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(user.details.name, style: context.style.b1),
                      AppSpacing.h4,
                      Text(widget.replyTo.comment.content.text!),
                    ],
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h12,
        ],
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
            onSuffixIconTapped: addCommentReply,
          );
        },
      ),
    );
  }

  Widget _buildComments() {
    final commentReplyStream = ref.watch(getCommentStream(repliesRef));
    return Expanded(
      child: Padding(
        padding: AppPadding.p8,
        child: commentReplyStream.when(
          data: (replies) {
            return ListView.separated(
              itemBuilder: (context, index) {
                return CommentBubble(
                  id: widget.replyTo.id,
                  commentsRef: repliesRef,
                  comments: (
                    prev: index == 0 ? null : replies[index - 1],
                    current: replies[index],
                  ),

                  allowReply: false,
                );
              },
              separatorBuilder: (context, index) {
                return AppSpacing.h8;
              },
              itemCount: replies.length,
            );
          },
          error: error,
          loading: loader,
        ),
      ),
    );
  }
}
