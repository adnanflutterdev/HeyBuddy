import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_chip.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/features/auth/presentation/riverpod/auth_provider.dart';
import 'package:hey_buddy/features/profile/data/models/user.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/toggle_edit_provider.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/update_user_data_provider.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/user_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;

  final ValueNotifier<File?> _coverImage = .new(null);
  final ValueNotifier<File?> _profileImage = .new(null);
  final ValueNotifier<List<Interest>> _interests = .new([]);

  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDob;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = .new();
    _dobController = .new();
    _locationController = .new();
    _bioController = .new();
    _websiteController = .new();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    _interests.dispose();
    _coverImage.dispose();
    _profileImage.dispose();
    super.dispose();
  }

  void pickFromCamera() async {
    final result = await ImagePicker().pickImage(source: .camera);
    if (result != null) {
      AppNavigator.pop(File(result.path));
    } else {
      AppNavigator.pop(null);
    }
  }

  void pickFromGallery() async {
    final result = await ImagePicker().pickImage(
      source: .gallery,
      requestFullMetadata: true,
    );
    if (result != null) {
      AppNavigator.pop(File(result.path));
    } else {
      AppNavigator.pop(null);
    }
  }

  Future<File?> showSelectionImageSource() async {
    return await showModalBottomSheet<File?>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            color: context.colors.appbar,
            padding: AppPadding.p16,
            child: Row(
              spacing: 15,
              children: [
                _buildImageSourceButton(
                  onPressed: pickFromCamera,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                ),
                _buildImageSourceButton(
                  onPressed: pickFromGallery,
                  icon: Icons.folder,
                  label: 'Gallery',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void updateUserData() async {
    if (_formKey.currentState!.validate()) {
      //
      _formKey.currentState?.save();

      Details prevDetails = ref.read(userProvider).value!.details as Details;
      Profile prevProfile = ref.read(userProvider).value!.profile as Profile;

      Details details = Details(
        name: _nameController.text.trim(),
        email: prevDetails.email,
        dob: _selectedDob != null
            ? Timestamp.fromDate(_selectedDob!)
            : prevDetails.dob,
        gender: _selectedGender ?? prevDetails.gender,
      );

      Profile profile = Profile(
        profileImage: prevProfile.profileImage,
        coverImage: prevProfile.coverImage,
        bio: _bioController.text.trim(),
        location: _locationController.text.trim(),
        website: _websiteController.text.trim(),
        interests: _interests.value,
      );

      final result = await ref
          .read(updateUserDataProvider.notifier)
          .updateUserData(details, profile);

      if (mounted) {
        showMessenger(context, result: result);
        ref.read(toggleEditProvider.notifier).toggleEdit();
        final _ = ref.refresh(userProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRef = ref.watch(userProvider);
    final editRef = ref.watch(toggleEditProvider);
    final updateRef = ref.watch(updateUserDataProvider);

    return Scaffold(
      body: userRef.when(
        data: (user) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: AppPadding.p12,
              children: [
                _buildProfile(user.profile, editRef),
                AppSpacing.h16,
                _buildUserDetails(user.details, editRef),
                AppSpacing.h16,
                _buildProfileDetails(user.profile, editRef),
                AppSpacing.h16,
                _buildAccountInfo(user.account),
                AppSpacing.h16,
                _buildLogoutButton(),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return const SizedBox.shrink();
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: _buildSaveButton(editRef, updateRef),
    );
  }

  Widget? _buildSaveButton(bool canEdit, AsyncValue updateRef) {
    return canEdit
        ? updateRef.when(
            data: (result) {
              return PrimaryButton(onPressed: updateUserData, label: 'Save');
            },
            error: (_, _) {
              return null;
            },
            loading: () {
              return const PrimaryButton(
                onPressed: null,
                isLoading: true,
                label: 'Save',
              );
            },
          )
        : null;
  }

  Widget _buildProfile(ProfileEnity profile, bool canEdit) {
    return SizedBox(
      width: context.width,
      height: 250,
      child: Stack(
        children: [
          // Cover Image
          ValueListenableBuilder(
            valueListenable: _coverImage,
            builder: (context, coverImage, child) {
              if (coverImage != null) {
                return _buildCoverImage(
                  image: DecorationImage(
                    image: FileImage(coverImage),
                    fit: .cover,
                  ),
                );
              }
              return CachedNetworkImage(
                imageUrl: profile.coverImage ?? '',
                placeholder: (context, url) {
                  return _buildCoverImage();
                },
                imageBuilder: (context, imageProvider) {
                  return _buildCoverImage(
                    image: DecorationImage(image: imageProvider, fit: .cover),
                  );
                },
                errorWidget: (context, url, error) {
                  return _buildCoverImage(
                    child: const Center(child: Text('No Cover Image Added')),
                  );
                },
              );
            },
          ),

          if (canEdit)
            Positioned(
              right: 0,
              child: _buildIconButton(
                onPressed: () async {
                  _coverImage.value = await showSelectionImageSource();
                },
                image: profile.coverImage,
              ),
            ),

          // Profile Image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: .center,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _profileImage,
                    builder: (context, profileImage, child) {
                      if (profileImage != null) {
                        return _buildProfileImage(
                          DecorationImage(
                            image: FileImage(profileImage),
                            fit: .cover,
                          ),
                        );
                      }
                      return CachedNetworkImage(
                        imageUrl: profile.profileImage ?? '',
                        placeholder: (context, url) {
                          return const AppLogo(size: 120);
                        },
                        imageBuilder: (context, imageProvider) {
                          return _buildProfileImage(
                            DecorationImage(image: imageProvider, fit: .cover),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return const AppLogo(size: 120);
                        },
                      );
                    },
                  ),
                  if (canEdit)
                    Positioned(
                      left: (context.width / 2),
                      bottom: 0,
                      child: _buildIconButton(
                        onPressed: () async {
                          _profileImage.value =
                              await showSelectionImageSource();
                        },
                        image: profile.profileImage,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required Function()? onPressed,
    required String? image,
  }) {
    return Material(
      color: context.colors.bg,
      shape: CircleBorder(side: BorderSide(color: context.colors.border)),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: context.colors.disabledText,
        child: Padding(
          padding: AppPadding.p8,
          child: Icon(
            image == null ? Icons.add_a_photo : Icons.repeat_outlined,
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage({Widget? child, DecorationImage? image}) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.colors.container,
        image: image,
        border: Border.all(color: context.colors.border),
      ),
      child: child,
    );
  }

  Widget _buildProfileImage(DecorationImage image) {
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

  Widget _buildUserDetails(DetailsEntity details, bool canEdit) {
    DateTime? dob = details.dob?.toDate();
    String? dobString = dob != null ? DateFormat.yMMMd().format(dob) : null;
    _nameController.text = details.name;
    _dobController.text = dobString ?? 'DOB';

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
            border: Border.all(color: context.colors.border),
          ),

          padding: AppPadding.p16,

          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              _buildInfoCol(
                heading: 'Name',
                text: details.name,
                child: canEdit ? _nameField() : null,
              ),
              _buildInfoCol(heading: 'Email', text: details.email),

              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _buildInfoCol(
                      heading: 'DOB',
                      text: dobString ?? '',
                      child: canEdit ? _dobField(dob) : null,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCol(
                      heading: 'Gender',
                      text: details.gender?.name.capitalizeFirst ?? '',
                      child: canEdit ? _buildGender(details.gender) : null,
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

  Widget _nameField() {
    return AppTextField(
      controller: _nameController,
      validator: AppValidators.name,
    );
  }

  Widget _dobField(DateTime? dob) {
    return AppTextField(
      isReadOnly: true,
      controller: _dobController,
      suffixIcon: Icons.calendar_month_outlined,
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime lastDate = DateTime(now.year - 15, now.month, now.day);
        DateTime initialDate = _selectedDob != null
            ? DateTime(
                _selectedDob!.year,
                _selectedDob!.month,
                _selectedDob!.day,
              )
            : (dob != null ? DateTime(dob.year, dob.month, dob.day) : lastDate);
        DateTime? pickedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: lastDate,
          initialDate: initialDate,
        );
        if (pickedDate != null) {
          _selectedDob = pickedDate;
          _dobController.text = DateFormat.yMMMd().format(pickedDate);
        }
      },
    );
  }

  Widget _buildGender(Gender? gender) {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField(
        initialValue: gender?.name,
        hint: Text('Gender', style: context.style.b2),
        style: context.style.b2,
        items: Gender.values
            .map(
              (g) => DropdownMenuItem(
                value: g.name.toString(),
                child: Text(g.name.toString().capitalizeFirst),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            _selectedGender = GenderX.fromFirebase(value);
          }
        },
      ),
    );
  }

  Widget _buildProfileDetails(ProfileEnity profile, bool canEdit) {
    _locationController.text = profile.location ?? '';
    _bioController.text = profile.bio ?? '';
    _interests.value = profile.interests ?? [];
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Profile Details',
          style: context.style.h2.copyWith(color: context.colors.neonBlue),
        ),
        AppSpacing.h12,
        Container(
          width: context.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: context.colors.container,
            border: Border.all(color: context.colors.border),
          ),

          padding: AppPadding.p16,

          child: Column(
            spacing: 12,
            crossAxisAlignment: .start,
            children: [
              _buildInterests(profile.interests ?? [], canEdit),
              _buildInfoCol(
                heading: 'Location',
                text: profile.location ?? '',
                child: canEdit ? _locationField() : null,
              ),
              _buildInfoCol(
                heading: 'Website',
                text: profile.website ?? '',
                child: canEdit ? _websiteField() : null,
              ),
              _buildInfoCol(
                heading: 'Bio',
                text: profile.bio ?? '',
                child: canEdit ? _bioField() : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _locationField() {
    return AppTextField(
      controller: _locationController,
      validator: AppValidators.address,
    );
  }

  Widget _websiteField() {
    return AppTextField(
      controller: _websiteController,
      validator: AppValidators.url,
    );
  }

  Widget _bioField() {
    return AppTextField(
      maxLines: 4,
      minLines: 1,
      controller: _bioController,
      validator: AppValidators.bio,
    );
  }

  Widget _buildInterests(List<Interest> interests, bool canEdit) {
    return Column(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: 'Interests',
          style: context.style.b1.copyWith(color: context.colors.neonGreen),
        ),

        if (interests.isEmpty && !canEdit)
          Text('N/A', style: context.style.h3)
        else
          ValueListenableBuilder(
            valueListenable: _interests,
            builder: (context, selectedInterests, child) {
              return Wrap(
                spacing: 10,
                runSpacing: 8,
                children: (canEdit ? Interest.values : interests).map((
                  interest,
                ) {
                  bool contains = selectedInterests.contains(interest);
                  return AppChip(
                    label: interest.name.capitalizeFirst,
                    onPressed: canEdit
                        ? () {
                            List<Interest> newInterests = selectedInterests;
                            if (contains) {
                              selectedInterests.remove(interest);
                            } else {
                              selectedInterests.add(interest);
                            }
                            _interests.value = [...newInterests];
                          }
                        : null,
                    icon: canEdit ? (contains ? Icons.check : Icons.add) : null,
                    radius: contains ? 15 : null,
                    foregroundColor: (contains && canEdit)
                        ? context.colors.neonGreen
                        : null,
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  Widget _buildAccountInfo(AccountEntity account) {
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
            border: Border.all(color: context.colors.border),
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
    required String text,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: heading,
          style: context.style.b1.copyWith(color: context.colors.neonGreen),
        ),
        child ?? Text(text.isEmpty ? 'N/A' : text, style: context.style.h3),
      ],
    );
  }

  Widget _buildImageSourceButton({
    required Function() onPressed,
    required IconData icon,
    required String label,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: .min,
        spacing: 4,
        children: [
          Container(
            decoration: BoxDecoration(shape: .circle, color: context.colors.bg),
            padding: AppPadding.p8,
            child: Icon(icon, size: 30),
          ),
          Text(label, style: context.style.h3),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
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
