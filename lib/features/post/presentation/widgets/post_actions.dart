import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';
import 'package:hey_buddy/features/feed/riverpod/post_actions_provider.dart';
import 'package:hey_buddy/features/post/presentation/widgets/post_comments.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.container,
      padding: AppPadding.p12,
      child: Row(
        spacing: 20,
        children: [
          _buildLikeButton(),
          _buildCommentButton(context),
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              const Icon(Icons.share),
              Text('0', style: context.style.b2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    void toggleLike(WidgetRef ref, String uid, bool isLiked) {
      final notifier = ref.read(postActionProvider.notifier);
      notifier.togglePostLikeUsecase(id: id, uid: uid, isLiked: isLiked);
    }

    return Consumer(
      builder: (context, ref, _) {
        final uid = ref.read(uidProvider);
        final likeStream = ref.watch(postLikeStream(id));
        return likeStream.when(
          data: (likes) {
            bool isLiked = likes.contains(uid);
            return Row(
              mainAxisSize: .min,
              spacing: 8,
              children: [
                GestureDetector(
                  onTap: () => toggleLike(ref, uid, isLiked),
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_outline,
                    color: isLiked ? context.colors.error : null,
                  ),
                ),
                Text('${likes.length}', style: context.style.b2),
              ],
            );
          },
          error: (_, _) {
            return Row(
              mainAxisSize: .min,
              spacing: 8,
              children: [
                const Icon(Icons.favorite),
                Text('0', style: context.style.b2),
              ],
            );
          },
          loading: () {
            return Row(
              mainAxisSize: .min,
              spacing: 8,
              children: [
                const Icon(Icons.favorite),
                Text('0', style: context.style.b2),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCommentButton(BuildContext context) {
    void openCommentSheet(String id) {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        builder: (context) {
          return PostComments(id: id);
        },
      );
    }

    return GestureDetector(
      onTap: () => openCommentSheet(id),
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          const Icon(Icons.comment),
          Consumer(
            builder: (context, ref, _) {
              final commentStream = ref.watch(getCommentStream(id));
              return commentStream.when(
                data: (data) {
                  return Text('${data.length}', style: context.style.b2);
                },
                error: (_, _) => const Text('0'),
                loading: () => const Text('0'),
              );
            },
          ),
        ],
      ),
    );
  }
}
