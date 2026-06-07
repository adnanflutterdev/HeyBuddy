import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/clip_actions.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/clip_player.dart';

class BuildClip extends StatelessWidget {
  const BuildClip({super.key, required this.clip, required this.controller});
  final Clip clip;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!controller.value.isInitialized)
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: clip.content.media.data.thumbnail!,
            ),
          )
        else
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black,
              child: ClipPlayer(controller: controller),
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
