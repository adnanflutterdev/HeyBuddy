import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/core/utils/messenger.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/material_icon_button.dart';
import 'package:hey_buddy/core/widgets/primary_button.dart';
import 'package:hey_buddy/features/post/presentation/widgets/crop_image.dart';
import 'package:image_picker/image_picker.dart';

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
    final pickedImages = await ImagePicker().pickMultiImage(
      limit: 10,
      imageQuality: 70,
    );

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
    final pickedImage = await ImagePicker().pickImage(
      source: .gallery,
      imageQuality: 70,
    );

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
    Uint8List imageData = await _images[_pageIndex].readAsBytes();
    File croppedImage = await AppNavigator.push(
      CropImage(imageData: imageData),
    );
    _images[_pageIndex] = croppedImage;
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

  @override
  Widget build(BuildContext context) {
    GetColor colors = context.colors;
    return Scaffold(
      appBar: CustomAppBar(
        title: ('New', ' Post'),
        actions: [
          PrimaryButton(
            onPressed: () {},
            label: 'Upload',
            height: 35,
            style: context.style.h3.copyWith(
              color: colors.neonGreen,
              letterSpacing: 2,
              fontFamily: 'Joti',
            ),
          ),
        ],
      ),
      body: Padding(
        padding: AppPadding.p16,
        child: Column(
          spacing: 10,
          children: [
            if (_images.isEmpty)
              const Expanded(child: Center(child: Text('No Images Yet')))
            else
              Expanded(
                child: Stack(
                  children: [
                    PageView.builder(
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
                    ),

                    Positioned(
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
                          MaterialIconButton(
                            onPressed: cropImage,
                            icon: Icons.crop,
                          ),
                          MaterialIconButton(
                            onPressed: removeImage,
                            icon: Icons.close,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
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
            ),
            AppTextField(
              hintText: 'Write something',
              controller: _contentController,
              minLines: 1,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
