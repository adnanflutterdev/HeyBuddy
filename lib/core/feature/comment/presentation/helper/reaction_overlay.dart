import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';

OverlayEntry openReactionOverlay({
  required TapDownDetails details,
  required BuildContext context,
  required OverlayEntry? overlayEntry,
  required Function(({String reactionName, String reactionEmoji})) addReaction,
  required VoidCallback removeReactionOverlay,
  required String currentReaction,
}) {
  final Offset offset = details.globalPosition;

  List<({String reactionName, String reactionEmoji})> reactions = [
    (reactionName: 'Like', reactionEmoji: '👍'),
    (reactionName: 'Love', reactionEmoji: '❤️'),
    (reactionName: 'Funny', reactionEmoji: '😂'),
    (reactionName: 'Shoking', reactionEmoji: '😮'),
    (reactionName: 'Sad', reactionEmoji: '😢'),
    (reactionName: 'Angry', reactionEmoji: '😡'),
  ];

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: removeReactionOverlay)),
          Positioned(
            left: 30,
            top: offset.dy - 40,
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.container,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    offset: Offset.zero,
                    blurRadius: 2,
                    color: context.colors.shadow,
                  ),
                ],
              ),
              padding: AppPadding.p8,
              child: Row(
                children: reactions
                    .map(
                      (reaction) => AppMaterialButton(
                        hasCircularBorder: true,
                        text: reaction.reactionEmoji,
                        onPressed: () {
                          if (currentReaction != reaction.reactionEmoji) {
                            addReaction(reaction);
                          } else {
                            removeReactionOverlay();
                          }
                        },
                        padding: AppPadding.p8,
                        isTransparent:
                            currentReaction != reaction.reactionEmoji,
                        style: context.style.h1,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      );
    },
  );
  return overlayEntry;
}
