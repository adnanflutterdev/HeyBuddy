import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/clip_actions.dart';

class BuildClip extends StatelessWidget {
  const BuildClip({super.key, required this.clip});
  final Clip clip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: clip.content.media.data.thumbnail!,
          ),
        ),
        Positioned(
          top: 0,
          right: 10,
          bottom: 0,
          child: ClipActions(clipId: clip.id),
        ),
      ],
    );
  }
}
