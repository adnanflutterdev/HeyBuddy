import 'dart:io';
import 'package:heybuddy/MyVideoPlayer/source_type.dart';

class MyVideoPlayerController {
  dynamic source;
  SourceType sourceType;
  bool? autoPlay;
  bool? looping;
  bool? backgroundPlay;
  double? playBackSpeed;

  MyVideoPlayerController.asset(
      {required String this.source, this.autoPlay, this.looping, this.backgroundPlay, this.playBackSpeed})
      : sourceType = SourceType.asset;
  MyVideoPlayerController.contentUri(
      {required Uri this.source, this.autoPlay, this.looping, this.backgroundPlay, this.playBackSpeed})
      : sourceType = SourceType.contentUri;
  MyVideoPlayerController.file(
      {required File this.source, this.autoPlay, this.looping, this.backgroundPlay, this.playBackSpeed})
      : sourceType = SourceType.file;
  MyVideoPlayerController.url(
      {required Uri this.source, this.autoPlay, this.looping, this.backgroundPlay, this.playBackSpeed})
      : sourceType = SourceType.networkUrl;
}
