import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_actions_provider.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_provider.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/clip_actions.dart';
import 'package:video_player/video_player.dart';

class ClipPlayer extends ConsumerStatefulWidget {
  const ClipPlayer({
    super.key,
    required this.controller,
    required this.isMuted,
    required this.clipId,
    required this.aspectRatio,
  });
  final VideoPlayerController controller;
  final ValueNotifier<bool> isMuted;
  final String clipId;
  final double aspectRatio;

  @override
  ConsumerState<ClipPlayer> createState() => _ClipPlayerState();
}

class _ClipPlayerState extends ConsumerState<ClipPlayer>
    with SingleTickerProviderStateMixin {
  VideoPlayerController get controller => widget.controller;
  final ValueNotifier<bool> _isUiVisible = ValueNotifier(false);
  final ValueNotifier<bool> _isFastForwarded = ValueNotifier(false);

  late AnimationController _animationController;
  late Animation<double> _likeAnimation;
  OverlayEntry? _overlayEntry;

  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    if (widget.isMuted.value) {
      controller.setVolume(0);
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _likeAnimation = Tween<double>(begin: 0.2, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.addStatusListener((status) {
      if (status == .completed) {
        _animationController.reset();
        if (_overlayEntry != null) {
          _overlayEntry?.remove();
          _overlayEntry = null;
        }
      }
    });
  }

  void addLike(TapDownDetails details) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    final uid = ref.read(uidProvider);
    final likeStream = ref.read(clipLikeStream(widget.clipId));

    if (likeStream.value != null && !likeStream.value!.contains(uid)) {
      ref
          .read(clipActionProvider.notifier)
          .toggleClipLike(id: widget.clipId, uid: uid, isLiked: false);
    }

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
          width: context.width,
          height: context.height,
          child: Stack(
            children: [
              Positioned(
                left: details.globalPosition.dx - 40,
                top: details.globalPosition.dy - 40,
                child: ScaleTransition(
                  scale: _likeAnimation,
                  child: Icon(
                    Icons.favorite,
                    size: 80,
                    color: context.colors.error,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (_overlayEntry != null) {
      overlay.insert(_overlayEntry!);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    _isUiVisible.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          // Video
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
              },

              onDoubleTapDown: addLike,

              onLongPressStart: (details) async {
                await controller.setPlaybackSpeed(2);
                _isFastForwarded.value = true;
              },
              onLongPressEnd: (details) async {
                await controller.setPlaybackSpeed(1);
                _isFastForwarded.value = false;
              },

              child: VideoPlayer(controller),
            ),
          ),
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: .center,
              children: [
                ValueListenableBuilder(
                  valueListenable: _isFastForwarded,
                  builder: (context, isFastForwarded, _) {
                    if (!isFastForwarded) {
                      return const SizedBox.shrink();
                    }
                    return const AppMeterialButton(
                      text: '2X',
                      iconAlignment: .end,
                      icon: Icons.fast_forward,
                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  if (!value.isPlaying) {
                    return AppMeterialButton(
                      onPressed: () {
                        controller.play();
                      },
                      icon: Icons.pause,
                      iconSize: 30,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 10,
            bottom: 100,
            child: ClipActions(clipId: widget.clipId),
          ),
        ],
      ),
    );
  }
}
