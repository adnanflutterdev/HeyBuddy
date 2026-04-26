import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/model/image_upload_data.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/riverpod/upload_progress_provider.dart';
import 'package:hey_buddy/core/utils/file_uploader.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/material_icon_button.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/features/feed/data/models/feed_item.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/user_data_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:uuid/uuid.dart';

class PostUploadScreeen extends StatefulWidget {
  const PostUploadScreeen({super.key});

  @override
  State<PostUploadScreeen> createState() => _PostUploadScreeenState();
}

class _PostUploadScreeenState extends State<PostUploadScreeen> {
  int _pageIndex = 0;
  List<File> _images = [];
  final double _thumbnailSize = 50;
  final PageController _pageController = .new();
  final ScrollController _scrollController = .new();
  final TextEditingController _contentController = .new();

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage(limit: 10);

    if (pickedImages.isNotEmpty) {
      _images.addAll(pickedImages.map((xFile) => File(xFile.path)));

      if (_images.length > 10) {
        _images = _images.take(10).toList();
        if (mounted) {
          showMessenger(
            context,
            result: Result(
              success: false,
              message: 'Only 10 images allowed per post',
            ),
          );
        }
      }
      setState(() {});
    }
  }

  void replaceImage() async {
    final pickedImage = await ImagePicker().pickImage(source: .gallery);

    if (pickedImage != null) {
      _images[_pageIndex] = File(pickedImage.path);

      setState(() {});
    }
  }

  void removeImage() {
    final removeAt = _pageIndex;
    if (_pageIndex == _images.length - 1) {
      _pageIndex--;
    }
    _images.removeAt(removeAt);
    setState(() {});
  }

  void cropImage() async {
    final croppedImage = await ImageCropper.platform.cropImage(
      sourcePath: _images[_pageIndex].path,
      uiSettings: [
        AndroidUiSettings(activeControlsWidgetColor: context.colors.neonBlue),
      ],
    );

    if (croppedImage != null) {
      _images[_pageIndex] = File(croppedImage.path);
      setState(() {});
    }
  }

  void scrollToIndex(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(
        milliseconds: ((_pageIndex - index).abs() * 200).clamp(200, 800),
      ),
      curve: Curves.easeIn,
    );
  }

  void scrollThumbnails() {
    final thumbnailWidth = _thumbnailSize + 12;
    final width = (context.width - 32) / 2;

    double offset =
        ((_pageIndex + 1) * thumbnailWidth) - width + (thumbnailWidth / 2);
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  void uploadPost(WidgetRef ref) async {
    String text = _contentController.text.trim();
    if (text.isNotEmpty || _images.isNotEmpty) {
      String postId = const Uuid().v4();
      UserEntity? user = ref.read(userProvider).value;
      if (user == null) {
        if (mounted) {
          showMessenger(
            context,
            result: Result.failure('Failed to fetch your data'),
          );
        }
        return;
      }
      List<ImageUploadData>? images;
      if (_images.isNotEmpty) {
        String uid = ref.read(uidProvider);
        List<String> names = _images
            .map(
              (file) =>
                  'post/$uid/$postId/${XFile(file.path).name.split('.').first}',
            )
            .toList();
        List<ImageUploadData>? uploadedImages = await FileUploader.uploadFiles(
          _images,
          names,
          ref,
        );
        if (uploadedImages == null) {
          if (mounted) {
            showMessenger(
              context,
              result: Result.failure('Failed to upload images'),
            );
          }
          return;
        } else {
          images = uploadedImages;
        }
      }
      List<Media>? media = images
          ?.map((imageData) => Media(data: imageData, type: .image))
          .toList();
      Content content = Content(
        text: text,
        media: media,
        tags: [],
        type: .post,
      );
      FeedItemUser feedItemUser = FeedItemUser(
        ref: ref
            .read(firebaseFirestoreProvider)
            .collection('user')
            .doc(user.uid),
        id: user.uid,
        name: user.details.name,
        profileImage: user.profile.profileImage,
      );
      FeedItem feedItem = FeedItem.setNewPost(
        id: postId,
        user: feedItemUser,
        content: content,
      );
      Result result = await ref
          .read(createPostProvider.notifier)
          .uploadFeedItem(feedItem);
      if (mounted) {
        showMessenger(context, result: result);
        ref.read(uploadProgressProvider.notifier).updateProgress(0);
        Future.delayed(const Duration(milliseconds: 200), () {
          AppNavigator.pop();
        });
      }
    } else {
      showMessenger(
        context,
        result: Result.failure('Add images/content to upload post'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ('New', ' Post'),
        actions: [_buildUploadButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.p16,
          child: Column(
            spacing: 10,
            children: [
              if (_images.isEmpty)
                const Expanded(child: Center(child: Text('No Images Yet')))
              else
                Expanded(
                  child: Stack(
                    children: [_buildImages(), _buildImageActionButtons()],
                  ),
                ),
              _buildImagesPreview(),
              AppTextField(
                hintText: 'Write something',
                controller: _contentController,
                minLines: 1,
                maxLines: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return Consumer(
      builder: (context, ref, _) {
        final progress = ref.watch(uploadProgressProvider);
        final createPostRef = ref.watch(createPostProvider);

        if (createPostRef.isLoading || progress > 0) {
          return PrimaryButton(
            onPressed: null,
            isLoading: true,
            progress: progress,
            label: progress < 100 ? '' : 'Uploading',
            style: context.style.h3.copyWith(
              color: context.colors.neonGreen,
              letterSpacing: 2,
              fontFamily: 'Joti',
            ),
          );
        }
        return PrimaryButton(
          onPressed: () => uploadPost(ref),
          label: 'Upload',
          height: 35,
          style: context.style.h3.copyWith(
            color: context.colors.neonGreen,
            letterSpacing: 2,
            fontFamily: 'Joti',
          ),
        );
      },
    );
  }

  Widget _buildImageActionButtons() {
    return Positioned(
      top: 0,
      right: 0,
      child: Row(
        spacing: 10,
        mainAxisAlignment: .end,
        children: [
          MaterialIconButton(
            onPressed: replaceImage,
            icon: Icons.repeat_outlined,
          ),
          MaterialIconButton(onPressed: cropImage, icon: Icons.crop),
          MaterialIconButton(onPressed: removeImage, icon: Icons.close),
        ],
      ),
    );
  }

  Widget _buildImages() {
    return PageView.builder(
      itemCount: _images.length,
      controller: _pageController,
      onPageChanged: (value) {
        _pageIndex = value;
        scrollThumbnails();
        setState(() {});
      },
      itemBuilder: (context, index) {
        return InteractiveViewer(
          maxScale: 10,
          child: Image.file(_images[index]),
        );
      },
    );
  }

  Widget _buildImagesPreview() {
    GetColor colors = context.colors;
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: .horizontal,
        controller: _scrollController,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: pickImages,
              child: Container(
                width: _thumbnailSize,
                height: _thumbnailSize,
                decoration: BoxDecoration(
                  color: colors.container,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: const Center(child: Icon(Icons.add, size: 30)),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () => scrollToIndex(index - 1),
              child: Container(
                width: _thumbnailSize,
                height: _thumbnailSize,
                decoration: BoxDecoration(
                  color: colors.container,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (_pageIndex == index - 1)
                        ? colors.neonBlue
                        : colors.border,
                    width: (_pageIndex == index - 1) ? 3 : 1,
                  ),
                  image: DecorationImage(
                    fit: .cover,
                    image: FileImage(_images[index - 1]),
                  ),
                ),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return AppSpacing.w12;
        },
        itemCount: _images.length + 1,
      ),
    );
  }
}
