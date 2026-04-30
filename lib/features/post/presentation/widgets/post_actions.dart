import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.container,
      padding: AppPadding.p12,
      child: Row(
        spacing: 12,
        children: [
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              const Icon(Icons.favorite),
              Text('0', style: context.style.b2),
            ],
          ),
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              const Icon(Icons.comment),
              Text('0', style: context.style.b2),
            ],
          ),
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              const Icon(Icons.share),
              Text('0', style: context.style.b2),
            ],
          ),
        ],
      ),
    );
  }
}
