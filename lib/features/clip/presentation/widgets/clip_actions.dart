import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_icons.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/open_bottom_sheet.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/feature/comment/presentation/screens/comments_sheet.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_actions_provider.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_provider.dart';

class ClipActions extends ConsumerStatefulWidget {
  const ClipActions({super.key, required this.clipId});
  final String clipId;

  @override
  ConsumerState<ClipActions> createState() => _ClipActionsState();
}

class _ClipActionsState extends ConsumerState<ClipActions> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  Image getIcon(String icon) {
    return Image.asset(icon, width: 30);
  }

  StrokeText getText(String text) {
    return StrokeText(
      text: text,
      style: context.style.b1.copyWith(color: Colors.white),
    );
  }

  void toggleLike(WidgetRef ref, String uid, bool isLiked) {
    final notifier = ref.read(clipActionProvider.notifier);
    notifier.toggleClipLike(id: widget.clipId, uid: uid, isLiked: isLiked);
  }

  void openCommentSheet(CollectionReference commentsRef) {
    openBottomSheet(
      context: context,
      sheet: CommentsSheet(id: widget.clipId, commentsRef: commentsRef),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
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
      ),
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
              child: getIcon(
                isLiked ? AppIcons.heartFilled : AppIcons.heartOutlined,
              ),
            ),
            getText('${likes.length}'),
          ],
        );
      },
      error: (_, _) {
        return getIcon(AppIcons.heartOutlined);
      },
      loading: () {
        return getIcon(AppIcons.heartOutlined);
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
      onTap: () => openCommentSheet(commentsRef),
      child: Column(
        mainAxisSize: .min,
        children: [
          getIcon(AppIcons.comment),
          commentStream.when(
            data: (data) => getText('${data.length}'),
            error: (_, _) => getIcon(AppIcons.comment),
            loading: () => getIcon(AppIcons.comment),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton() {
    return Column(
      mainAxisSize: .min,
      children: [getIcon(AppIcons.share), getText('0')],
    );
  }

  Widget _buildSendButton() {
    return Column(
      mainAxisSize: .min,
      children: [getIcon(AppIcons.send), getText('0')],
    );
  }

  Widget _buildSaveButton() {
    return Column(
      mainAxisSize: .min,
      children: [getIcon(AppIcons.saveOutlined), getText('0')],
    );
  }

  Widget _buildMoreButton() {
    return getIcon(AppIcons.more);
  }
}
