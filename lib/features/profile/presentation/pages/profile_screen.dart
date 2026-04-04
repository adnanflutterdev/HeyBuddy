import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/auth_provider.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/user_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRef = ref.watch(userProvider);

    return userRef.when(
      data: (user) {
        return ListView(
          padding: AppPadding.p12,
          children: [
            _buildProfile(context, user.profile),
            AppSpacing.h16,
            _buildUserDetails(context, user.details),
            AppSpacing.h16,
            _buildAccountInfo(context, user.account),
            AppSpacing.h16,
            _buildLogoutButton(context),
          ],
        );
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildProfile(BuildContext context, ProfileEnity profile) {
    return SizedBox(
      width: context.width,
      height: 250,
      child: Stack(
        children: [
          // Cover Image
          CachedNetworkImage(
            imageUrl: profile.coverImage ?? '',
            placeholder: (context, url) {
              return _buildCoverPlaceholder(context);
            },
            imageBuilder: (context, imageProvider) {
              return _buildCoverPlaceholder(
                context,
                image: DecorationImage(image: imageProvider, fit: .cover),
              );
            },
            errorWidget: (context, url, error) {
              return _buildCoverPlaceholder(
                context,
                child: const Center(child: Text('No Cover Image Added')),
              );
            },
          ),

          // Profile Image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CachedNetworkImage(
              imageUrl: profile.profileImage ?? '',
              placeholder: (context, url) {
                return const AppLogo(size: 120);
              },
              imageBuilder: (context, imageProvider) {
                return _buildProfileImage(
                  context,
                  DecorationImage(image: imageProvider, fit: .cover),
                );
              },
              errorWidget: (context, url, error) {
                return const AppLogo(size: 120);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverPlaceholder(
    BuildContext context, {
    Widget? child,
    DecorationImage? image,
  }) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.colors.container,
        image: image,
      ),
      child: child,
    );
  }

  Widget _buildProfileImage(BuildContext context, DecorationImage image) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: .circle,
        color: context.colors.container,
        image: image,
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context, DetailsEntity details) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Personal Details',
          style: context.style.h2.copyWith(color: context.colors.neonBlue),
        ),
        AppSpacing.h12,
        Container(
          width: context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.colors.container,
          ),

          padding: AppPadding.p16,

          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              _buildInfoCol(context, heading: 'Name', text: details.name),
              _buildInfoCol(context, heading: 'Email', text: details.email),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoCol(
                      context,
                      heading: 'DOB',
                      text: details.dob?.toString() ?? 'N/A',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCol(
                      context,
                      heading: 'Gender',
                      text: details.gender ?? 'N/A',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfo(BuildContext context, AccountEntity account) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Account Details',
          style: context.style.h2.copyWith(color: context.colors.neonBlue),
        ),
        AppSpacing.h12,
        Container(
          width: context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.colors.container,
          ),

          padding: AppPadding.p16,

          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCol(
                      context,
                      heading: 'Account Type',
                      text: account.accountType.name,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCol(
                      context,
                      heading: 'Account Status',
                      text: account.isVerified ? 'Verified' : 'Not Verfied',
                    ),
                  ),
                ],
              ),
              _buildInfoCol(
                context,
                heading: 'Created At',
                text: DateFormat.yMMMEd().format(account.createdAt.toDate()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCol(
    BuildContext context, {
    required String heading,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: heading,
          style: context.style.b1.copyWith(color: context.colors.neonGreen),
        ),

        Text(text, style: context.style.h3),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Align(
          alignment: .center,
          child: PrimaryButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
            },
            label: 'Logout',
            icon: Icons.logout_outlined,
            iconSize: 27,
            alignment: .end,
            backgroundColor: context.colors.error,
            foregroundColor: context.colors.primaryText,
          ),
        );
      },
    );
  }
}
