import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/MyVideoPlayer/full_screen_mode.dart';
import 'package:heybuddy/MyVideoPlayer/my_progress_bar.dart';
import 'package:heybuddy/MyVideoPlayer/screen_orientation.dart';
import 'package:heybuddy/MyVideoPlayer/source_type.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview(
      {super.key,
      required this.sourceType,
      required this.screenOrientation,
      required this.source,
      required this.autoPlay,
      required this.looping,
      required this.backgroundPlay,
      required this.playBackSpeed,
      this.lastPosition,
      this.isPlaying});
  final SourceType sourceType;
  final ScreenOrientation screenOrientation;
  final dynamic source;
  final bool autoPlay;
  final bool looping;
  final bool backgroundPlay;
  final double playBackSpeed;
  final Duration? lastPosition;
  final bool? isPlaying;

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController videoPlayerController;

// labels
  double length = 0;
  String lengthLabel = '';
  int fastForwardLabel = 0;
  int fastRewinedLabel = 0;
  double currentPosition = 0;
  String currentPositionLabel = '';
  double bufferedPosition = 10;

  // Volume
  double volume = 1.0;

  // speed
  double currentSpeed = 1.0;
  bool isSpeedBarVisible = false;
  List speeds = [
    0.25,
    0.50,
    0.75,
    1.0,
    1.25,
    1.50,
    1.75,
    2.0,
  ];

  // Ui displaying
  bool isPlaying = false;
  bool isCompleted = false;
  bool isVolumeVisible = false;
  bool isControlsVisible = true;
  bool fastForwardVisible = false;
  bool fastRewinedVisible = false;
  bool isInitializing = true;
  bool isBuffering = false;

  //

  // Timer
  Timer? uiControllsTimer;
  Timer? fastForwardTimer;
  Timer? fastRewinedTimer;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    VideoPlayerOptions videoPlayerOptions =
        VideoPlayerOptions(allowBackgroundPlayback: widget.backgroundPlay);
    if (widget.sourceType == SourceType.asset) {
      videoPlayerController = VideoPlayerController.asset(widget.source,
          videoPlayerOptions: videoPlayerOptions);
    } else if (widget.sourceType == SourceType.contentUri) {
      videoPlayerController = VideoPlayerController.contentUri(widget.source,
          videoPlayerOptions: videoPlayerOptions);
    } else if (widget.sourceType == SourceType.file) {
      videoPlayerController = VideoPlayerController.file(widget.source,
          videoPlayerOptions: videoPlayerOptions);
    } else {
      videoPlayerController = VideoPlayerController.networkUrl(widget.source,
          videoPlayerOptions: videoPlayerOptions);
    }
    videoPlayerController.initialize().then((e) {
      length = videoPlayerController.value.duration.inSeconds.toDouble();
      lengthLabel = getLabel(length: length);
      videoPlayerController.setLooping(widget.looping);
      currentSpeed = widget.playBackSpeed;
      videoPlayerController.setPlaybackSpeed(currentSpeed);

      if (widget.lastPosition != null) {
        currentPosition = widget.lastPosition!.inSeconds.toDouble();
        videoPlayerController.seekTo(widget.lastPosition!);
        isPlaying = widget.isPlaying!;
      } else {
        isPlaying = widget.autoPlay;
      }

      if (isPlaying) {
        videoPlayerController.play();
      }
      isInitializing = false;
      setState(() {});
    });

    // VideoPlayer Listener.
    videoPlayerController.addListener(() {
      currentPosition =
          videoPlayerController.value.position.inSeconds.toDouble();
      currentPositionLabel = getLabel(length: currentPosition);
      if (videoPlayerController.value.buffered.isNotEmpty) {
        bufferedPosition =
            videoPlayerController.value.buffered.last.end.inSeconds.toDouble();
      }
      if (videoPlayerController.value.isBuffering) {
        isBuffering = true;
      } else {
        isBuffering = false;
      }
      if (videoPlayerController.value.isCompleted) {
        isCompleted = true;
        isPlaying = false;
      } else {
        isCompleted = false;
      }
      setState(() {});
    });
  }

  void playPause() {
    cancelTimer();
    startTimer();
    isPlaying ? videoPlayerController.pause() : videoPlayerController.play();
    isPlaying = !isPlaying;
    setState(() {});
  }

  String getLabel({required double length}) {
    final hr = ((length ~/ 60) ~/ 60);
    final min = ((length ~/ 60) % 60).toInt();
    final sec = (length % 60).toInt();
    return '${hr > 0 ? (hr < 10 ? '0$hr:' : '$hr:') : ''}${min < 10 ? '0$min' : min}:${sec < 10 ? '0$sec' : sec}';
  }

  void fastRewined() {
    fastRewinedVisible = true;
    if (fastRewinedTimer != null && fastRewinedTimer!.isActive) {
      fastRewinedTimer!.cancel();
    }
    currentPosition = (currentPosition - 10).clamp(0, length);
    if (currentPosition >= 0) {
      fastRewinedLabel += 10;
      videoPlayerController.seekTo(Duration(seconds: currentPosition.toInt()));
    }
    setState(() {});
    fastRewinedTimer = Timer(Duration(seconds: 1), () {
      fastRewinedVisible = false;
      fastRewinedLabel = 0;
      setState(() {});
    });
  }

  void fastForward() {
    fastForwardVisible = true;
    if (fastForwardTimer != null && fastForwardTimer!.isActive) {
      fastForwardTimer!.cancel();
    }
    currentPosition = (currentPosition + 10).clamp(0, length);
    if (currentPosition <= length) {
      fastForwardLabel += 10;
      videoPlayerController.seekTo(Duration(seconds: currentPosition.toInt()));
    }
    setState(() {});
    fastForwardTimer = Timer(Duration(seconds: 1), () {
      fastForwardVisible = false;
      fastForwardLabel = 0;
      setState(() {});
    });
  }

  void startTimer() {
    uiControllsTimer = Timer(Duration(seconds: 3), () {
      isControlsVisible = false;
      setState(() {});
    });
  }

  void cancelTimer() {
    if (uiControllsTimer != null && uiControllsTimer!.isActive) {
      uiControllsTimer!.cancel();
    }
  }

  void controlsTimer() {
    isSpeedBarVisible = false;
    if (isControlsVisible) {
      cancelTimer();
      isControlsVisible = false;
    } else {
      cancelTimer();
      isControlsVisible = true;
      startTimer();
    }
    setState(() {});
  }

  void changeSpeed() {
    if (uiControllsTimer != null && uiControllsTimer!.isActive) {
      uiControllsTimer!.cancel();
    }
    isControlsVisible = false;
    isSpeedBarVisible = true;
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = w / videoPlayerController.value.aspectRatio;
    debugprint(videoPlayerController.value.aspectRatio);
    return isInitializing
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController),
                  ),
                ),

                // Middle screen with gesture detector
                Center(
                    child: GestureDetector(
                  onTapDown: (details) {
                    if (details.localPosition.dx < w / 2) {
                      if (fastRewinedVisible) {
                        fastRewined();
                      } else {
                        controlsTimer();
                      }
                    } else {
                      if (fastForwardVisible) {
                        fastForward();
                      } else {
                        controlsTimer();
                      }
                    }
                  },
                  onDoubleTapDown: (details) {
                    if (details.localPosition.dx < w / 2) {
                      fastRewined();
                    } else {
                      fastForward();
                    }
                  },
                  child: Container(
                    width: w,
                    height: h,
                    color: Colors.transparent,
                  ),
                )),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w / 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (fastRewinedVisible || isControlsVisible)
                            TextButton.icon(
                                label: Text(
                                  fastRewinedLabel == 0
                                      ? ''
                                      : '-${fastRewinedLabel}s',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: fastRewined,
                                icon: Icon(
                                  Icons.fast_rewind,
                                  size: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(-1, 1))
                                  ],
                                )),
                          if (fastForwardVisible || isControlsVisible)
                            TextButton.icon(
                                iconAlignment: IconAlignment.end,
                                label: Text(
                                  fastForwardLabel == 0
                                      ? ''
                                      : '+${fastForwardLabel}s',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                onPressed: fastForward,
                                icon: Icon(
                                  Icons.fast_forward,
                                  size: 30,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1))
                                  ],
                                ))
                        ]),
                  ),
                ),
                // Play and pause button
                Center(
                  child: Container(
                      width: 60,
                      height: 60,
                      color: Colors.transparent,
                      child: isBuffering
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : isCompleted
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black26),
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          videoPlayerController
                                              .seekTo(Duration.zero);
                                          videoPlayerController.play();
                                          Timer(Duration(milliseconds: 100),
                                              () {
                                            setState(() {
                                              isPlaying = true;
                                            });
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        size: 30,
                                        color: Colors.white,
                                      )),
                                )
                              : isControlsVisible
                                  ? Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black26),
                                      child: IconButton(
                                          onPressed: playPause,
                                          icon: Icon(
                                            isPlaying
                                                ? Icons.play_arrow
                                                : Icons.pause,
                                            size: 40,
                                            color: Colors.white,
                                          )),
                                    )
                                  : IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.play_arrow,
                                        size: 30,
                                        color: Colors.transparent,
                                      ),
                                    )),
                ),

                // Bottom of the screen
                // Video label, volume and exit fullscreen
                if (isControlsVisible)
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 25,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              '$currentPositionLabel/$lengthLabel',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                        color: Colors.black,
                                        blurRadius: 3,
                                        offset: Offset(0, 1)),
                                  ]),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                if (volume > 0) {
                                  volume = 0.0;
                                  videoPlayerController.setVolume(volume);
                                  setState(() {});
                                } else {
                                  volume = 1.0;
                                  videoPlayerController.setVolume(volume);
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                volume == 0.0
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                shadows: [
                                  Shadow(
                                      color: Colors.black, offset: Offset(1, 1))
                                ],
                                color: Colors.white,
                                size: 25,
                              )),
                          // full screen button
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () async {
                                isControlsVisible = false;
                                videoPlayerController.pause();
                                final result = await Navigator.of(context)
                                    .push<Map>(MaterialPageRoute(
                                        builder: (context) => FullScreenMode(
                                              screenOrientation:
                                                  videoPlayerController.value
                                                              .aspectRatio >
                                                          1
                                                      ? ScreenOrientation
                                                          .landscape
                                                      : ScreenOrientation
                                                          .portraitFull,
                                              sourceType: widget.sourceType,
                                              source: widget.source,
                                              isPlaying: isPlaying,
                                              lastPosition:
                                                  videoPlayerController
                                                      .value.position,
                                              looping: widget.looping,
                                              backgroundPlay:
                                                  widget.backgroundPlay,
                                              playBackSpeed: currentSpeed,
                                            )));

                                // Getting last videoPlayer data and updating
                                if (result != null) {
                                  currentPosition = result['currentPosition'];
                                  videoPlayerController
                                      .seekTo(result['playingPosition']);
                                  volume = result['volume'];
                                  videoPlayerController.setVolume(volume);
                                  isPlaying = result['isPlaying'];

                                  if (isPlaying) {
                                    videoPlayerController.play();
                                  }
                                  setState(() {});
                                }
                              },
                              icon: Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                                size: 25,
                              )),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                  ),

                // Video progress bar
                if (isControlsVisible)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: MyProgressBar(
                        width: w - 30,
                        trackHeight: 5,
                        maxValue: length,
                        currentPosition: currentPosition,
                        bufferedPosition: bufferedPosition,
                        bufferedColor: Colors.white,
                        onChanged: (value) {
                          currentPosition = value;
                          setState(() {});
                          videoPlayerController.seekTo(
                              Duration(seconds: currentPosition.toInt()));
                          cancelTimer();
                          startTimer();
                        },
                        onChangeStart: (value) {
                          cancelTimer();
                        },
                        onChangeEnd: (value) {
                          cancelTimer();
                          startTimer();
                        },
                      ),
                    ),
                  ),
                // speed bar
                if (isSpeedBarVisible)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.blueGrey,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: speeds.map(
                          (s) {
                            return GestureDetector(
                              onTap: () {
                                currentSpeed = s;
                                videoPlayerController
                                    .setPlaybackSpeed(currentSpeed);
                                isSpeedBarVisible = false;
                                setState(() {});
                              },
                              child: Container(
                                color: currentSpeed == s
                                    ? Colors.blueAccent
                                    : Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 2),
                                  child: Text(
                                    '${s}x',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                // Top of the screen
                if (isControlsVisible)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: changeSpeed,
                        icon: Icon(
                          Icons.speed_sharp,
                          size: 25,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black, offset: Offset(1, 1))
                          ],
                        )),
                  ),
              ],
            ),
          );
  }
}

//
