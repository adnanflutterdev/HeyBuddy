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
import 'package:hey_buddy/core/model/media_meta.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/riverpod/upload_progress_provider.dart';
import 'package:hey_buddy/core/utils/file_uploader.dart';
import 'package:hey_buddy/core/utils/image_picker_helper.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/image_viewer.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_chip.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/features/profile/data/models/user_data_model.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/update_my_data_provider.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class EditMyProfile extends StatefulWidget {
  const EditMyProfile({super.key, required this.myData});
  final UserData myData;

  @override
  State<EditMyProfile> createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _locationController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;

  final ValueNotifier<File?> _coverImage = .new(null);
  final ValueNotifier<File?> _profileImage = .new(null);
  final ValueNotifier<List<Interest>> _interests = .new([]);

  final _formKey = GlobalKey<FormState>();

  DateTime? dob;
  DateTime? _selectedDob;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();

    Details details = widget.myData.details;
    Profile profile = widget.myData.profile;

    dob = details.dob?.toDate();
    _nameController = .new(text: details.name);
    _dobController = .new(
      text: dob != null ? DateFormat.yMMMd().format(dob!) : 'DOB',
    );

    _interests.value = [...?profile.interests];
    _locationController = .new(text: profile.location);
    _bioController = .new(text: profile.bio);
    _websiteController = .new(text: profile.website);
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

  void updateUserData(WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      Details prevDetails = widget.myData.details;
      Profile prevProfile = widget.myData.profile;

      String? coverImage = prevProfile.coverImage;
      String? profileImage = prevProfile.profileImage;

      if (_coverImage.value != null || _profileImage.value != null) {
        List<File> files = [?_coverImage.value, ?_profileImage.value];
        List<String> folder = [
          if (_coverImage.value != null) 'coverImage',
          if (_profileImage.value != null) 'profileImage',
        ];
        List<String> names = [ref.read(uidProvider), ref.read(uidProvider)];

        List<MediaMeta>? urls = await FileUploader.uploadFiles(
          ref: ref,
          files: files,
          names: names,
          folder: folder,
        );
        if (urls == null || urls.isEmpty) {
          if (mounted) {
            showMessenger(
              context,
              result: Result.failure('Failed to upload image'),
            );
            return;
          }
        } else {
          if (_coverImage.value != null) {
            coverImage = urls[0].url;
          }
          if (_profileImage.value != null) {
            profileImage = urls[_coverImage.value != null ? 1 : 0].url;
          }
        }
      }

      DetailsModel details = DetailsModel(
        name: _nameController.text.trim(),
        email: prevDetails.email,
        dob: _selectedDob != null
            ? Timestamp.fromDate(_selectedDob!)
            : prevDetails.dob,
        gender: _selectedGender ?? prevDetails.gender,
      );

      ProfileModel profile = ProfileModel(
        coverImage: coverImage,
        profileImage: profileImage,
        interests: _interests.value,
        bio: _bioController.text.trim(),
        location: _locationController.text.trim(),
        website: _websiteController.text.trim(),
      );

      final result = await ref
          .read(updateMyDataProvider.notifier)
          .updateMyData(ref.read(uidProvider), details, profile);

      if (mounted) {
        showMessenger(context, result: result);
        ref.read(uploadProgressProvider.notifier).updateProgress(0);
        if (result.success) {
          final _ = ref.refresh(myDataProvider);
          AppNavigator.pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ('Editing Profile', ''),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final updateRef = ref.watch(updateMyDataProvider);
              final progress = ref.watch(uploadProgressProvider);

              if (updateRef.isLoading || progress > 0) {
                return AppMeterialButton(text: '$progress %');
              } else {
                return AppMeterialButton(
                  text: 'Save',
                  icon: Icons.save,
                  onPressed: () => updateUserData(ref),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: AppPadding.p12,
            children: [
              _buildProfile(widget.myData.profile),
              AppSpacing.h16,
              _buildUserDetails(widget.myData.details),
              AppSpacing.h16,
              _buildProfileDetails(widget.myData.profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(Profile profile) {
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
                  return GestureDetector(
                    onTap: () {
                      AppNavigator.push(
                        ImageViewer(images: [profile.coverImage!]),
                      );
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
              );
            },
          ),

          Positioned(
            right: 0,
            child: ValueListenableBuilder(
              valueListenable: _coverImage,
              builder: (context, coverImage, child) {
                return AppMeterialButton(
                  onPressed: () async {
                    final newImage =
                        await ImagePickerHelper.showSelectionImageSource(
                          context,
                        );
                    if (newImage != null) {
                      _coverImage.value = newImage;
                    }
                  },
                  icon: (coverImage != null || profile.coverImage != null)
                      ? Icons.repeat_outlined
                      : Icons.add_a_photo,
                );
              },
            ),
          ),

          // Profile Image
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder(
              valueListenable: _profileImage,
              builder: (context, profileImage, child) {
                return SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: .center,
                    children: [
                      if (profileImage != null)
                        _buildFileImage(
                          DecorationImage(
                            image: FileImage(profileImage),
                            fit: .cover,
                          ),
                        )
                      else
                        ProfileImage(imageUrl: profile.profileImage, size: 120),

                      Positioned(
                        left: (context.width / 2),
                        bottom: 0,
                        child: AppMeterialButton(
                          onPressed: () async {
                            final newImage =
                                await ImagePickerHelper.showSelectionImageSource(
                                  context,
                                );
                            if (newImage != null) {
                              _profileImage.value = newImage;
                            }
                          },
                          icon:
                              (profileImage != null ||
                                  profile.profileImage != null)
                              ? Icons.repeat_outlined
                              : Icons.add_a_photo,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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

  Widget _buildFileImage(DecorationImage image) {
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

  Widget _buildUserDetails(Details details) {
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
              _buildInfoCol(heading: 'Name', child: _nameField()),
              _buildInfoCol(heading: 'Email', child: Text(details.email)),
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _buildInfoCol(heading: 'DOB', child: _dobField()),
                  ),
                  Expanded(
                    child: _buildInfoCol(
                      heading: 'Gender',
                      child: _buildGender(details.gender),
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

  Widget _dobField() {
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
            : (dob != null
                  ? DateTime(dob!.year, dob!.month, dob!.day)
                  : lastDate);
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

  Widget _buildProfileDetails(Profile profile) {
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
              _buildInterests(profile.interests ?? []),
              _buildInfoCol(heading: 'Location', child: _locationField()),
              _buildInfoCol(heading: 'Website', child: _websiteField()),
              _buildInfoCol(heading: 'Bio', child: _bioField()),
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
      maxLengths: 500,
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
        ValueListenableBuilder(
          valueListenable: _interests,
          builder: (context, selectedInterests, child) {
            return Wrap(
              spacing: 10,
              runSpacing: 8,
              children: Interest.values.map((interest) {
                bool contains = selectedInterests.contains(interest);
                return AppChip(
                  label: interest.name.capitalizeFirst,
                  onPressed: () {
                    List<Interest> newInterests = [...selectedInterests];
                    if (contains) {
                      newInterests.remove(interest);
                    } else {
                      newInterests.add(interest);
                    }
                    _interests.value = newInterests;
                  },
                  icon: contains ? Icons.check : Icons.add,
                  radius: contains ? 15 : null,
                  foregroundColor: (contains) ? context.colors.neonGreen : null,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInfoCol({required String heading, required Widget child}) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        StrokeText(
          text: heading,
          style: context.style.b1.copyWith(color: context.colors.neonGreen),
        ),
        child,
      ],
    );
  }
}
