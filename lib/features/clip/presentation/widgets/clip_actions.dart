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

  List<Shadow> shadows = [
    const Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
  ];

  late TextStyle style = context.style.b2.copyWith(
    color: Colors.white,
    shadows: shadows,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      mainAxisAlignment: .end,
      children: [
        _buildLikeButton(),
        _buildCommentButton(),
        _buildShareButton(),
        _buildSendButton(),
        _buildSaveButton(),
        _buildMoreButton(),
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
                color: isLiked ? context.colors.error : Colors.white,
                size: 30,
                shadows: shadows,
              ),
            ),

            Text(
              '${likes.length}',
              style: context.style.b2.copyWith(
                color: Colors.white,
                shadows: shadows,
              ),
            ),
          ],
        );
      },
      error: (_, _) {
        return Icon(Icons.favorite, color: Colors.white, shadows: shadows);
      },
      loading: () {
        return Icon(Icons.favorite, color: Colors.white, shadows: shadows);
      },
    );
  }

  Widget _buildCommentButton() {
    final firestore = ref.watch(firebaseFirestoreProvider);
    final commentsRef = firestore
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
          Icon(Icons.comment, size: 30, color: Colors.white, shadows: shadows),
          commentStream.when(
            data: (data) {
              return Text('${data.length}', style: style);
            },
            error: (_, _) =>
                Icon(Icons.comment, color: Colors.white, shadows: shadows),
            loading: () =>
                Icon(Icons.comment, color: Colors.white, shadows: shadows),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(Icons.share, size: 30, color: Colors.white, shadows: shadows),
        Text('0', style: style),
      ],
    );
  }

  Widget _buildSendButton() {
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(
          Icons.send_rounded,
          size: 30,
          color: Colors.white,
          shadows: shadows,
        ),
        Text('0', style: style),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(
          Icons.bookmark_outline,
          size: 30,
          color: Colors.white,
          shadows: shadows,
        ),
        Text('0', style: style),
      ],
    );
  }

  Widget _buildMoreButton() {
    return Icon(
      Icons.more_vert,
      size: 30,
      color: Colors.white,
      shadows: shadows,
    );
  }
}
