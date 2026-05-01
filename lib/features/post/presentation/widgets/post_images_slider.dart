import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/post/presentation/pages/image_viewer.dart';

class PostImagesSlider extends StatefulWidget {
  const PostImagesSlider({super.key, required this.media});
  final List<MediaEntity> media;

  @override
  State<PostImagesSlider> createState() => _PostImagesSliderState();
}

class _PostImagesSliderState extends State<PostImagesSlider> {
  final ValueNotifier<int> _pageIndex = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.media.fold(0.0, (prev, ele) => prev + ele.data.aspectRatio) /
        widget.media.length;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            AppNavigator.push(
              ImageViewer(images: widget.media, pageIndex: _pageIndex.value),
            );
          },
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: widget.media.length,
                  onPageChanged: (value) {
                    _pageIndex.value = value;
                  },
                  itemBuilder: (context, index) {
                    MediaEntity img = widget.media[index];
                    return CachedNetworkImage(
                      imageUrl: img.data.url,
                      fit: .cover,
                      placeholder: (context, url) {
                        return Center(
                          child: Container(color: context.colors.card),
                        );
                      },
                    );
                  },
                ),
                if (widget.media.length > 1)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.colors.bg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: AppPadding.symmetric(8, 4),
                      child: ValueListenableBuilder(
                        valueListenable: _pageIndex,
                        builder: (context, pageIndex, _) {
                          return Text(
                            '${pageIndex + 1}/${widget.media.length}',
                            style: context.style.bs1.copyWith(letterSpacing: 2),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.media.length > 1)
          Padding(
            padding: AppPadding.v8,
            child: Row(
              spacing: 5,
              mainAxisAlignment: .center,
              children: List.generate(widget.media.length, (index) {
                return ValueListenableBuilder(
                  valueListenable: _pageIndex,
                  builder: (context, pageIndex, child) {
                    return Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: .circle,
                        color: pageIndex == index
                            ? context.colors.neonGreen
                            : context.colors.primaryText,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
      ],
    );
  }
}
