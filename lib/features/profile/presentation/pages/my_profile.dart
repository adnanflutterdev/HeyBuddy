import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_formater_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/app_validators.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_chip.dart';
import 'package:hey_buddy/core/widgets/collapsible_text.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/image_viewer.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/auth_provider.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/pages/edit_my_profile.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  void openUrl(String url) async {
    String? email = AppValidators.email(url);
    Uri uri = Uri.parse(email == null ? 'mailto:$url?subject=Hey Buddy' : url);
    final result = await launchUrl(uri);
    if (!result && mounted) {
      showMessenger(context, result: Result.failure('Failed to open url'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final myDataRef = ref.watch(myDataProvider);
        return myDataRef.when(
          data: (myData) {
            return Scaffold(
              appBar: CustomAppBar(
                title: ('My Profile', ''),  
                actions: [
                  AppMeterialButton(
                    text: 'Edit',
                    icon: Icons.edit,
                    onPressed: () {
                      AppNavigator.push(EditMyProfile(myData: myData));
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: ListView(
                  padding: AppPadding.p12,
                  children: [
                    _buildProfile(myData.profile),
                    AppSpacing.h16,
                    _buildUserDetails(myData.details),
                    AppSpacing.h16,
                    _buildProfileDetails(myData.profile),
                    AppSpacing.h16,
                    _buildAccountInfo(myData.account),
                    AppSpacing.h16,
                    _buildLogoutButton(),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) {
            return const Scaffold(
              body: Center(child: Text('Something went wrong')),
            );
          },
          loading: loader,
        );
      },
    );
  }

  Widget _buildProfile(Profile profile) {
    return SizedBox(
      width: context.width,
      height: 250,
      child: Stack(
        children: [
          // Cover Image
          CachedNetworkImage(
            imageUrl: profile.coverImage ?? '',
            placeholder: (context, url) {
              return _buildCoverImage();
            },
            imageBuilder: (context, imageProvider) {
              return GestureDetector(
                onTap: () {
                  AppNavigator.push(ImageViewer(images: [profile.coverImage!]));
                },
                child: _buildCoverImage(
                  image: DecorationImage(image: imageProvider, fit: .cover),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return _buildCoverImage(
                child: const Center(child: Text('No Cover Image Added')),
              );
            },
          ),

          // Profile Image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ProfileImage(imageUrl: profile.profileImage, size: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverImage({Widget? child, DecorationImage? image}) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.container,
        image: image,
        border: Border.all(color: colors.border),
      ),
      child: child,
    );
  }

  Widget _buildUserDetails(Details details) {
    final colors = context.colors;
    DateTime? dob = details.dob?.toDate();
    String? dobString = dob != null ? DateFormat.yMMMd().format(dob) : null;

    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Personal Details',
          style: context.style.h2.copyWith(color: colors.neonBlue),
        ),
        AppSpacing.h12,
        Container(
          width: context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colors.container,
            border: Border.all(color: colors.border),
          ),

          padding: AppPadding.p16,

          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              _buildInfoCol(heading: 'Name', text: details.name),
              _buildInfoCol(heading: 'Email', url: details.email),

              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _buildInfoCol(heading: 'DOB', text: dobString ?? ''),
                  ),
                  Expanded(
                    child: _buildInfoCol(
                      heading: 'Gender',
                      text: details.gender?.name.capitalizeFirst ?? '',
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

  Widget _buildProfileDetails(Profile profile) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Profile Details',
          style: context.style.h2.copyWith(color: colors.neonBlue),
        ),
        AppSpacing.h12,
        Container(
          width: context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colors.container,
            border: Border.all(color: colors.border),
          ),

          padding: AppPadding.p16,

          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              _buildInterests(profile.interests ?? []),
              _buildInfoCol(heading: 'Location', text: profile.location ?? ''),
              _buildInfoCol(heading: 'Website', url: profile.website),
              _buildInfoCol(
                heading: 'Bio',
                text: profile.bio,
                isCollapsable: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfo(Account account) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Account Details',
          style: context.style.h2.copyWith(color: colors.neonBlue),
        ),
        AppSpacing.h12,
        Container(
          width: context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colors.container,
            border: Border.all(color: colors.border),
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
                      heading: 'Account Type',
                      text: account.accountType.name,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCol(
                      heading: 'Account Status',
                      text: account.isVerified ? 'Verified' : 'Not Verfied',
                    ),
                  ),
                ],
              ),
              _buildInfoCol(
                heading: 'Created At',
                text: DateFormat.yMMMEd().format(account.createdAt.toDate()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCol({
    required String heading,
    String? text,
    bool isCollapsable = false,
    String? url,
  }) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: heading,
          style: context.style.b1.copyWith(color: colors.neonGreen),
        ),
        if (isCollapsable && text != null)
          CollapsibleText(text: text)
        else if (url != null)
          GestureDetector(
            onTap: () {
              openUrl(url);
            },
            child: Text(
              url,
              style: context.style.b2.copyWith(
                color: colors.neonBlue,
                decoration: .underline,
                decorationColor: colors.neonBlue,
              ),
            ),
          )
        else
          Text((text == null || text.isEmpty) ? 'N/A' : text),
      ],
    );
  }

  Widget _buildInterests(List<Interest> interests) {
    return Column(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Interests',
          style: context.style.b1.copyWith(color: context.colors.neonGreen),
        ),

        if (interests.isEmpty)
          Text('N/A', style: context.style.h3)
        else
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: interests.map((interest) {
              return AppChip(label: interest.name.capitalizeFirst, radius: 15);
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    final colors = context.colors;
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
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
          ),
        );
      },
    );
  }
}
