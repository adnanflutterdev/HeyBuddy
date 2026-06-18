import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/placeholder_image.dart';
import 'package:hey_buddy/core/widgets/image_viewer.dart';
import 'package:uuid/uuid.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.imageUrl,
    this.size = 40,
    this.onTap,
  });
  final String? imageUrl;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String image = imageUrl ?? placeholderImage;

    Widget placeHolder = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: .circle,
        color: context.colors.container,
      ),
    );
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) {
        return placeHolder;
      },
      imageBuilder: (context, imageProvider) {
        return Hero(
          tag: imageUrl == null ? const Uuid().v4() : imageUrl!,
          child: GestureDetector(
            onTap:
                onTap ??
                () {
                  AppNavigator.push(ImageViewer(images: [image]));
                },
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: .circle,
                color: context.colors.container,
                image: DecorationImage(image: imageProvider, fit: .contain),
              ),
            ),
          ),
        );
      },
      errorWidget: (_, _, _) => placeHolder,
    );
  }
}
