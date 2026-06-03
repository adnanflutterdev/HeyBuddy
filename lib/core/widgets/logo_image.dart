import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({
    super.key,
    this.size = 30,
    required this.image,
    required this.onPressed,
  });
  final double size;
  final String? image;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image ?? '',
      imageBuilder: (context, imageProvider) {
        return GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: .circle,
                image: DecorationImage(image: imageProvider),
              ),
            ),
          ),
        );
      },
      placeholder: (context, url) {
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: .circle,
              color: context.colors.container,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => const AppLogo(),
    );
  }
}
