import 'package:flutter/material.dart';
import 'package:heybuddy/MyVideoPlayer/my_video_player_controller.dart';
import 'package:heybuddy/MyVideoPlayer/screen_orientation.dart';
import 'package:heybuddy/MyVideoPlayer/video_preview.dart';


class MyVideoPlayer extends StatelessWidget {
  final MyVideoPlayerController myVideoPlayerController;

  const MyVideoPlayer(
      {super.key,
      required this.myVideoPlayerController,
      });

  @override
  Widget build(BuildContext context) {
    return VideoPreview(
      screenOrientation: ScreenOrientation.potrait,
      sourceType: myVideoPlayerController.sourceType,
      source: myVideoPlayerController.source,
      autoPlay: myVideoPlayerController.autoPlay ?? false,
      looping: myVideoPlayerController.looping ?? false,
      backgroundPlay: myVideoPlayerController.backgroundPlay ?? false,
      playBackSpeed: myVideoPlayerController.playBackSpeed ?? 1.0,
    );
  }
}
