import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({super.key, required this.images, this.pageIndex = 0});
  final List<String> images;
  final int pageIndex;

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  late int _pageIndex = widget.pageIndex;
  late final List<String> _images = widget.images;
  final double _thumbnailSize = 50;
  late final PageController _pageController = .new(
    initialPage: widget.pageIndex,
  );
  final ScrollController _scrollController = .new();

  bool isFullScreenMode = false;

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
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

  void toggleFullScreenMode() {
    if (isFullScreenMode) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
    isFullScreenMode = !isFullScreenMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          );
          AppNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: isFullScreenMode
            ? null
            : CustomAppBar(
                title: _images.length > 1
                    ? ('${_pageIndex + 1}', '/${_images.length}')
                    : null,
                actions: [
                  AppMeterialButton(
                    icon: Icons.fullscreen,
                    iconSize: 30,
                    isTransparent: true,
                    onPressed: toggleFullScreenMode,
                  ),
                ],
              ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(child: _buildImages()),
                    if (_images.length > 1 && !isFullScreenMode) ...[
                      AppSpacing.h12,
                      _buildImagesPreview(),
                      AppSpacing.h12,
                    ],
                  ],
                ),
              ),
              if (isFullScreenMode)
                Positioned(
                  top: 10,
                  right: 10,
                  child: AppMeterialButton(
                    icon: Icons.fullscreen_exit,
                    onPressed: toggleFullScreenMode,
                  ),
                ),
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
          child: Hero(
            tag: _images[index],
            child: CachedNetworkImage(imageUrl: _images[index]),
          ),
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
              imageUrl: _images[index],
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
