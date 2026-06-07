import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_progress_bar/my_progress_bar.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';

class ClipPreview extends StatefulWidget {
  const ClipPreview({super.key, required this.controller});
  final VideoPlayerController controller;

  @override
  State<ClipPreview> createState() => _ClipPreviewState();
}

class _ClipPreviewState extends State<ClipPreview> {
  VideoPlayerController get controller => widget.controller;

  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  final ValueNotifier<bool> _isUiVisible = ValueNotifier(true);
  final ValueNotifier<double> _currentPosition = ValueNotifier(0.0);

  Timer? uiTimer;

  @override
  void initState() {
    controller.addListener(controllerListener);
    hideUiAfterDelay();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ClipPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(controllerListener);
      widget.controller.addListener(controllerListener);
      _isMuted.value = false;
      _isUiVisible.value = true;
      _currentPosition.value = 0.0;
      hideUiAfterDelay();
    }
  }

  void showUi() {
    _isUiVisible.value = true;
    hideUiAfterDelay();
  }

  void hideUiAfterDelay() {
    uiTimer?.cancel();
    uiTimer = Timer(const Duration(seconds: 3), () {
      _isUiVisible.value = false;
    });
  }

  void controllerListener() {
    _currentPosition.value = controller.value.position.inSeconds.toDouble();
  }

  @override
  void dispose() {
    _isMuted.dispose();
    _currentPosition.dispose();

    uiTimer?.cancel();
    _isUiVisible.dispose();

    controller.removeListener(controllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: Stack(
        children: [
          // Video
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (_isUiVisible.value) {
                  uiTimer?.cancel();
                  _isUiVisible.value = false;
                } else {
                  showUi();
                }
              },
              child: VideoPlayer(controller),
            ),
          ),

          // Controlls
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: _isUiVisible,
              builder: (context, isUiVisible, child) {
                if (isUiVisible) {
                  return _buildUi();
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUi() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                return AppMeterialButton(
                  onPressed: () {
                    showUi();
                    if (value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                  icon: value.isPlaying ? Icons.pause : Icons.play_arrow,
                  iconSize: 30,
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 5,
          right: 5,
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _currentPosition,
                  builder: (context, currentPosition, _) {
                    return HorizontalProgressBar(
                      trackHeight: 5,
                      maxValue: controller.value.duration.inSeconds.toDouble(),
                      currentPosition: currentPosition,
                      onChanged: (value) {
                        showUi();
                        controller.seekTo(Duration(seconds: value.toInt()));
                      },
                    );
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _isMuted,
                builder: (context, isMuted, _) {
                  return AppMeterialButton(
                    onPressed: () {
                      showUi();
                      if (isMuted) {
                        controller.setVolume(1);
                      } else {
                        controller.setVolume(0);
                      }
                      _isMuted.value = !isMuted;
                    },
                    padding: const EdgeInsets.all(4),
                    icon: isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    iconSize: 30,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
