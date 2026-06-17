import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/open_bottom_sheet.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/feature/comment/presentation/screens/comments_sheet.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/post/presentation/riverpod/post_provider.dart';
import 'package:hey_buddy/features/post/presentation/riverpod/post_actions_provider.dart';

class PostActions extends ConsumerStatefulWidget {
  const PostActions({super.key, required this.postId});
  final String postId;

  @override
  ConsumerState<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends ConsumerState<PostActions> {
  void toggleLike(WidgetRef ref, String uid, bool isLiked) {
    final notifier = ref.read(postActionProvider.notifier);
    notifier.togglePostLike(id: widget.postId, uid: uid, isLiked: isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.container,
      padding: AppPadding.p12,
      child: Row(
        spacing: 20,
        children: [
          _buildLikeButton(),
          _buildCommentButton(),
          _buildShareButton(),
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    final uid = ref.read(uidProvider);
    final likeStream = ref.watch(postLikeStream(widget.postId));
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
            Text('Like', style: context.style.b2),
          ],
        );
      },
      loading: () {
        return Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            const Icon(Icons.favorite),
            Text('Like', style: context.style.b2),
          ],
        );
      },
    );
  }

  Widget _buildCommentButton() {
    final commentsRef = ref
        .watch(firebaseFirestoreProvider)
        .collection('post')
        .doc(widget.postId)
        .collection('comments');
    final commentStream = ref.watch(getCommentStream(commentsRef));
    return GestureDetector(
      onTap: () => openBottomSheet(
        context: context,
        sheet: CommentsSheet(id: widget.postId, commentsRef: commentsRef),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          const Icon(Icons.comment),
          commentStream.when(
            data: (data) {
              return Text('${data.length}');
            },
            error: (_, _) => const Text('Comments'),
            loading: () => const Text('Comments'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return const Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [Icon(Icons.share), Text('0')],
    );
  }
}
