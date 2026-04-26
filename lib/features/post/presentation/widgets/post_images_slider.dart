import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';

class PostImagesSlider extends StatelessWidget {
  const PostImagesSlider({super.key, required this.media});
  final List<MediaEntity> media;

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        media.fold(0.0, (prev, ele) => prev + ele.data.aspectRatio) /
        media.length;
    return AspectRatio(
      aspectRatio: aspectRatio.clamp(0.8, 1.8),
      child: PageView.builder(
        itemCount: media.length,
        itemBuilder: (context, index) {
          MediaEntity img = media[index];
          return CachedNetworkImage(
            imageUrl: img.data.url,
            fit: .cover,
            placeholder: (context, url) {
              return Center(child: Container(color: context.colors.card));
            },
          );
        },
      ),
    );
  }
}
