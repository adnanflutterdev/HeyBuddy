import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.images, required this.pageIndex});
  final List<MediaEntity> images;
  final int pageIndex;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late int _pageIndex = widget.pageIndex;
  late final List<MediaEntity> _images = widget.images;
  final double _thumbnailSize = 50;
  final PageController _pageController = .new();
  final ScrollController _scrollController = .new();

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          if (_images.length > 1)
            TitleText(text: ('${_pageIndex + 1}', '/${_images.length}')),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppPadding.p16,
          child: Column(
            spacing: 10,
            children: [
              Expanded(child: _buildImages()),
              if (_images.length > 1) _buildImagesPreview(),
            ],
          ),
        ),
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
          child: CachedNetworkImage(imageUrl: _images[index].data.url),
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
          return GestureDetector(
            onTap: () => scrollToIndex(index),
            child: CachedNetworkImage(
              imageUrl: _images[index].data.url,
              imageBuilder: (context, imageProvider) {
                return Container(
                  width: _thumbnailSize,
                  height: _thumbnailSize,
                  decoration: BoxDecoration(
                    color: colors.container,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (_pageIndex == index)
                          ? colors.neonBlue
                          : colors.border,
                      width: (_pageIndex == index) ? 3 : 1,
                    ),
                    image: DecorationImage(fit: .cover, image: imageProvider),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return AppSpacing.w12;
        },
        itemCount: _images.length,
      ),
    );
  }
}
