import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_reaction_usecase.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/get_reaction_usecase.dart';
import 'package:hey_buddy/core/feature/comment/presentation/widgets/reaction_sheet.dart';
import 'package:hey_buddy/core/model/reaction_data.dart';
import 'package:hey_buddy/core/utils/get_reaction_data.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/reaction_overlay.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/material_text_button.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class ReactionButton extends ConsumerWidget {
  const ReactionButton({
    super.key,
    required this.postId,
    required this.commentId,
    required this.params,
  });
  final String postId;
  final String commentId;
  final GetReactionParams params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OverlayEntry? overlayEntry;
    Reaction? myReaction;
    Widget loader() => MaterialTextButton(text: '😆', style: context.style.b3);

    void removeReactionOverlay() {
      if (overlayEntry != null) {
        overlayEntry?.remove();
        overlayEntry = null;
      }
    }

    Future<void> addReaction(
      ({String reactionEmoji, String reactionName}) reaction,
    ) async {
      removeReactionOverlay();
      String userId = ref.read(uidProvider);
      final commentNotifier = ref.read(commentProvider.notifier);
      ReactionModel reactionModel = ReactionModel(
        userId: userId,
        reactionName: reaction.reactionName,
        reactionEmoji: reaction.reactionEmoji,
        createAt: myReaction != null ? myReaction!.createAt : DateTime.now(),
        updatedAt: myReaction != null ? DateTime.now() : null,
      );
      AddReactionParams params = AddReactionParams(
        id: postId,
        commentId: commentId,
        reaction: reactionModel,
      );
      final result = await commentNotifier.addReaction(params);
      if (!result.success && context.mounted) {
        showMessenger(context, result: result);
      }
    }

    void showReactionOverlay(TapDownDetails details) {
      final overlay = Overlay.of(context);
      overlayEntry = openReactionOverlay(
        details: details,
        context: context,
        addReaction: addReaction,
        overlayEntry: overlayEntry,
        currentReaction: myReaction?.reactionEmoji ?? '',
        removeReactionOverlay: removeReactionOverlay,
      );
      if (overlayEntry != null) {
        overlay.insert(overlayEntry!);
      }
    }

    void openReactionDataSheet(ReactionData reactionData) {
      showModalBottomSheet(
        context: context,
        showDragHandle: true,
        useSafeArea: true,
        builder: (context) {
          return ReactionSheet(reactionData: reactionData);
        },
      );
    }

    final uid = ref.watch(uidProvider);
    final reactionsRef = ref.watch(getReactionStream(params));
    return reactionsRef.when(
      data: (reactions) {
        String text = '😆';
        ReactionData reactionData = getReactionData(
          reactions: reactions,
          uid: uid,
        );
        myReaction = reactionData.myReaction;
        if (reactionData.displayText.isNotEmpty) {
          text = reactionData.displayText;
        }
        return Row(
          children: [
            MaterialTextButton(
              text: text,
              onTapDown: showReactionOverlay,
              padding: AppPadding.p4,
              style: context.style.b3.copyWith(letterSpacing: -4),
            ),
            if (reactions.isNotEmpty)
              MaterialTextButton(
                text: '(${reactions.length})',
                style: context.style.bs3,
                padding: AppPadding.symmetric(2, 2),
                onPressed: () {
                  openReactionDataSheet(reactionData);
                },
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        return loader();
      },
      loading: () {
        return loader();
      },
    );
  }
}
