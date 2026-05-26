import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/feature/comment/domain/usecase/add_reaction_usecase.dart';
import 'package:hey_buddy/core/feature/comment/presentation/widgets/reaction_sheet.dart';
import 'package:hey_buddy/core/model/reaction_data.dart';
import 'package:hey_buddy/core/utils/get_reaction_data.dart';
import 'package:hey_buddy/core/feature/comment/presentation/helper/reaction_overlay.dart';
import 'package:hey_buddy/core/feature/comment/presentation/riverpod/comment_providers.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/material_text_button.dart';
import 'package:hey_buddy/core/model/reaction.dart';

class ReactionButton extends ConsumerStatefulWidget {
  const ReactionButton({super.key, required this.reactionsRef});
  final CollectionReference reactionsRef;

  @override
  ConsumerState<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends ConsumerState<ReactionButton> {
  Reaction? myReaction;
  OverlayEntry? overlayEntry;
  late String uid;

  @override
  initState() {
    super.initState();
    uid = ref.read(uidProvider);
  }

  Widget loader() {
    return MaterialTextButton(text: '😆', style: context.style.b3);
  }

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
    final commentNotifier = ref.read(commentProvider.notifier);
    ReactionModel newReaction = ReactionModel(
      userId: uid,
      reactionName: reaction.reactionName,
      reactionEmoji: reaction.reactionEmoji,
      createAt: myReaction != null ? myReaction!.createAt : DateTime.now(),
      updatedAt: myReaction != null ? DateTime.now() : null,
    );
    DocumentReference reactionRef = widget.reactionsRef.doc(uid);
    AddReactionParams params = AddReactionParams(reactionRef, newReaction);
    final result = await commentNotifier.addReaction(params);
    if (!result.success && mounted) {
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

  @override
  Widget build(BuildContext context) {
    final reactionsRef = ref.watch(getReactionStream(widget.reactionsRef));
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
      loading: loader,
    );
  }
}
