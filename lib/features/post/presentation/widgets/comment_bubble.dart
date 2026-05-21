import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/model/comment.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/widgets/material_text_button.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/users_provider.dart';
import 'package:intl/intl.dart';

class CommentBubble extends ConsumerWidget {
  const CommentBubble({super.key, required this.comments});
  final ({Comment? prev, Comment current}) comments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? date;
    final GetColor colors = context.colors;
    final String myUid = ref.watch(uidProvider);
    final bool isMine = comments.current.userId == myUid;

    if (comments.prev == null) {
      date = DateFormat.yMMMEd().format(comments.current.timestamps.createdAt);
    } else {
      String prevDate = DateFormat.yMMMEd().format(
        comments.prev!.timestamps.createdAt,
      );
      String currentDate = DateFormat.yMMMEd().format(
        comments.current.timestamps.createdAt,
      );
      if (prevDate != currentDate) {
        date = currentDate;
      }
    }
    OverlayEntry? overlayEntry;
    void openReactionMenu(TapDownDetails details) {
      final Offset offset = details.globalPosition;

      List<String> reactions = ['😆', '😂', '❤️', '😍', '😡'];
      final overlay = Overlay.of(context);
      overlayEntry = OverlayEntry(
        builder: (context) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (overlayEntry != null) {
                      overlayEntry?.remove();
                      overlayEntry = null;
                    }
                  },
                ),
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.container,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset.zero,
                        blurRadius: 2,
                        color: colors.shadow,
                      ),
                    ],
                  ),
                  padding: AppPadding.p8,
                  child: Row(
                    children: reactions
                        .map(
                          (reaction) => MaterialTextButton(
                            text: reaction,
                            onPressed: () {},
                            isTransparent: true,
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

      overlay.insert(overlayEntry!);
    }

    return Column(
      mainAxisSize: .min,
      children: [
        if (date != null)
          Padding(
            padding: AppPadding.v12,
            child: Container(
              padding: AppPadding.symmetric(8, 4),
              decoration: BoxDecoration(
                color: colors.container,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(date),
            ),
          ),
        Consumer(
          builder: (context, ref, child) {
            final userRef = ref.watch(
              usersDataProvider(comments.current.userId),
            );
            return userRef.when(
              data: (user) {
                return Row(
                  crossAxisAlignment: .start,
                  children: [
                    if (!isMine) ...[
                      ProfileImage(imageUrl: user.profile.profileImage),
                      AppSpacing.w8,
                    ],
                    Container(
                      width: context.width - (isMine ? 20 : 70),
                      alignment: isMine ? .centerRight : .centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              ((9 / 10) * context.width) - (isMine ? 0 : 50),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Container(
                              padding: AppPadding.symmetric(12, 6),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? colors.neonGreen.withValues(alpha: 0.3)
                                    : colors.neonBlue.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(12),
                                  topRight: const Radius.circular(12),
                                  bottomLeft: Radius.circular(isMine ? 12 : 0),
                                  bottomRight: Radius.circular(isMine ? 0 : 12),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: .end,
                                children: [
                                  Text(comments.current.content.text!),
                                  Text(
                                    DateFormat('hh:mm:a').format(
                                      comments.current.timestamps.createdAt,
                                    ),
                                    style: context.style.bs3.copyWith(
                                      fontWeight: .bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isMine) ...[
                              AppSpacing.h4,
                              Row(
                                mainAxisSize: .min,
                                children: [
                                  MaterialTextButton(
                                    text: '😆',
                                    onTapDown: openReactionMenu,
                                    style: context.style.b3,
                                  ),
                                  MaterialTextButton(
                                    text: 'Reply',
                                    onPressed: () {},
                                    style: context.style.b3.copyWith(
                                      color: colors.neonBlue,
                                    ),
                                  ),
                                  MaterialTextButton(
                                    text: 'View Replies',
                                    onPressed: () {},
                                    style: context.style.b3,
                                  ),
                                  Text('(0)', style: context.style.bs3),
                                ],
                              ),
                              AppSpacing.h4,
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) => const SizedBox.shrink(),
              loading: () => Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: colors.container,
                  shape: .circle,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
