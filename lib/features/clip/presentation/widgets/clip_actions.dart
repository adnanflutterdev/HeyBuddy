import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/open_comment_sheet.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/feature/comment/presentation/screens/comments_sheet.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_actions_provider.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_provider.dart';

class ClipActions extends ConsumerStatefulWidget {
  const ClipActions({super.key, required this.clipId});
  final String clipId;

  @override
  ConsumerState<ClipActions> createState() => _ClipActionsState();
}

class _ClipActionsState extends ConsumerState<ClipActions> {
  void toggleLike(WidgetRef ref, String uid, bool isLiked) {
    final notifier = ref.read(clipActionProvider.notifier);
    notifier.toggleClipLike(id: widget.clipId, uid: uid, isLiked: isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      mainAxisAlignment: .center,
      children: [
        _buildLikeButton(),
        _buildCommentButton(),
        _buildShareButton(),
      ],
    );
  }

  Widget _buildLikeButton() {
    final uid = ref.read(uidProvider);
    final likeStream = ref.watch(clipLikeStream(widget.clipId));
    return likeStream.when(
      data: (likes) {
        bool isLiked = likes.contains(uid);
        return Column(
          mainAxisSize: .min,
          children: [
            GestureDetector(
              onTap: () => toggleLike(ref, uid, isLiked),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline,
                color: isLiked ? context.colors.error : null,
                size: 30,
                shadows: [
                  Shadow(
                    blurRadius: 3,
                    color: isLiked
                        ? context.colors.primaryText
                        : context.colors.shadow,
                  ),
                ],
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
        .collection('clip')
        .doc(widget.clipId)
        .collection('comments');
    final commentStream = ref.watch(getCommentStream(commentsRef));
    return GestureDetector(
      onTap: () => openCommentSheet(
        context: context,
        sheet: CommentsSheet(id: widget.clipId, commentsRef: commentsRef),
      ),
      child: Column(
        mainAxisSize: .min,
        children: [
          const Icon(Icons.comment, size: 30, shadows: [Shadow(blurRadius: 3)]),
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
    return const Column(
      mainAxisSize: .min,
      children: [
        Icon(Icons.share, size: 30, shadows: [Shadow(blurRadius: 3)]),
        Text('0'),
      ],
    );
  }
}
