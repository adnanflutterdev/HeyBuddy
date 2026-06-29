import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/profile/domain/entity/social_interactions.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class UserCard extends ConsumerWidget {
  const UserCard({super.key, required this.user, required this.status});
  final UserData user;
  final RelationStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUid = ref.watch(uidProvider);
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: AppPadding.h12,
            child: Row(
              mainAxisAlignment: .center,
              children: [
                ProfileImage(imageUrl: user.profile.profileImage, size: 50),
                AppSpacing.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        '@${user.details.username}',
                        style: context.style.b1,
                      ),
                      Text(
                        user.details.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: context.style.bs1,
                      ),
                    ],
                  ),
                ),
                if (myUid == user.uid)
                  const Text('Me')
                else ...[
                  if (status.isInOthersRequests)
                    Row(
                      children: [
                        AppSpacing.w8,
                        AppMeterialButton(
                          text: 'Accept',
                          icon: Icons.check,
                          borderRadius: 8,
                          iconAlignment: .end,
                          iconColor: context.colors.success,
                        ),
                        AppSpacing.w8,
                        AppMeterialButton(
                          borderRadius: 8,
                          icon: Icons.close,
                          iconAlignment: .end,
                          iconColor: context.colors.error,
                        ),
                      ],
                    )
                  else if (status.isInMyRequests)
                    const AppMeterialButton(
                      text: 'Withdraw',
                      icon: Icons.person_remove,
                      iconAlignment: .end,
                    )
                  else
                    AppMeterialButton(
                      text: status.isFriend ? 'Friends' : 'Add',
                      icon: status.isFriend
                          ? Icons.person
                          : Icons.person_add_alt_1,
                      iconAlignment: .end,
                      style: status.isFriend
                          ? context.style.b2.copyWith(
                              color: context.colors.neonBlue,
                            )
                          : null,
                      iconColor: status.isFriend
                          ? context.colors.neonBlue
                          : null,
                      borderRadius: 8,
                      padding: AppPadding.symmetric(10, 6),
                    ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: AppPadding.symmetric(4, 8),
          child: const Divider(thickness: 0.5),
        ),
      ],
    );
  }
}
