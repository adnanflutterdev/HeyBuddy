import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/features/feed/data/models/comment.dart';
import 'package:hey_buddy/features/feed/data/models/timestamps.dart';
import 'package:hey_buddy/features/feed/domain/entity/comment_entity.dart';
import 'package:hey_buddy/features/feed/riverpod/add_comment_provider.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';
import 'package:hey_buddy/features/post/presentation/widgets/comment_bubble.dart';
import 'package:uuid/uuid.dart';

class PostComments extends StatefulWidget {
  const PostComments({super.key, required this.id});
  final String id;

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  double _height = 600;
  final TextEditingController _controller = .new();

  Future<void> addComment(WidgetRef ref) async {
    CommentEntity comment = Comment(
      id: const Uuid().v4(),
      userId: ref.read(uidProvider),
      content: CommentContent(text: _controller.text),
      timestamps: Timestamps(createdAt: DateTime.now()),
    );

    Result result = await ref
        .read(addCommentProvider.notifier)
        .addComment(widget.id, comment);

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
          children: [_buildDragger(), _buildCommentField(), _buildComments()],
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
          final addCommentRef = ref.watch(addCommentProvider);
          if (addCommentRef.isLoading) {
            return AppTextField(
              isSuffixIconLoading: true,
              controller: _controller,
              isReadOnly: true,
            );
          }
          return AppTextField(
            hintText: 'Write your comment',
            suffixIcon: Icons.send,
            controller: _controller,
            unfocousOnTapOutside: true,
            onSuffixIconTapped: () => addComment(ref),
          );
        },
      ),
    );
  }

  Widget _buildComments() {
    return Expanded(
      child: Padding(
        padding: AppPadding.p8,
        child: Consumer(
          builder: (context, ref, _) {
            final commentStream = ref.watch(getCommentStream(widget.id));
            return commentStream.when(
              data: (comments) {
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return CommentBubble(
                      comments: (
                        prev: index == 0 ? null : comments[index - 1],
                        current: comments[index],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return AppSpacing.h8;
                  },
                  itemCount: comments.length,
                );
              },
              error: (error, stackTrace) {
                return const SizedBox.expand();
              },
              loading: () {
                return const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
