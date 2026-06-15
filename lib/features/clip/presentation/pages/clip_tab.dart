import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:video_player/video_player.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/build_clip.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_provider.dart';

class ClipTab extends ConsumerStatefulWidget {
  const ClipTab({super.key, required this.pageController});

  final PageController pageController;

  @override
  ConsumerState<ClipTab> createState() => _ClipTabState();
}

class _ClipTabState extends ConsumerState<ClipTab> {
  final ValueNotifier<bool> _isMuted = ValueNotifier(false);
  List<VideoPlayerController?> _controllers = [];
  List<String> _urls = [];
  int currentPage = 0;

  void loadControllers(List<String> urls) {
    _urls = urls;
    _controllers = List.generate(_urls.length, (index) => null);
  }

  Future<void> initializeControllers(int index) async {
    int length = _controllers.length;
    List<int> indicesToInit = [];
    int? indexToDispose;
    if (index == 0) {
      indicesToInit = [index, index + 1];
      // Nothing to dispose
    } else if (index != length - 1) {
      indicesToInit = [index - 1, index, index + 1];
      if (index > 1) {
        indexToDispose = index - 2;
      }
    } else {
      indicesToInit = [index - 1, index];

      if (index > 1) {
        indexToDispose = index - 2;
      }
    }

    // Initializing Controllers
    for (int i in indicesToInit) {
      if (_controllers[i] == null) {
        final controller = VideoPlayerController.networkUrl(
          Uri.parse(_urls[i]),
        );
        await controller.initialize();
        await controller.setLooping(true);
        

        _controllers[i] = controller;
      }
    }
    // Disposing Controllers
    if (indexToDispose != null) {
      _controllers[indexToDispose]?.dispose();
      _controllers[indexToDispose] = null;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void playCurrentClip(int index) {
    if (mounted) {
      if (index == 0) {
        if (_urls.length > 1 && _controllers[1]!.value.isPlaying) {
          _controllers[1]?.pause();
        }
        _controllers[0]?.play();
      } else {
        _controllers[index - 1]?.pause();
        if (_urls.length - 1 > index) {
          _controllers[index + 1]?.pause();
        }
        _controllers[index]?.play();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller?.pause();
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clipsRef = ref.watch(clipsProvider);
    return clipsRef.when(
      data: (clips) {
        if (clips.isEmpty) {
          return const Center(child: Text('No clips found'));
        }
        if (_urls.isEmpty) {
          loadControllers(
            clips.map((clip) => clip.content.media.data.url).toList(),
          );

          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await initializeControllers(0);
            playCurrentClip(0);
          });
        }
        return Stack(
          children: [
            PageView.builder(
              scrollDirection: .vertical,
              itemCount: clips.length,
              onPageChanged: (index) async {
                currentPage = index;
                await initializeControllers(index);
                playCurrentClip(index);
              },
              itemBuilder: (context, index) {
                final controller = _controllers[index];

                if (controller == null || !controller.value.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BuildClip(
                  clip: clips[index],
                  isMuted: _isMuted,
                  controller: _controllers[index]!,
                );
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: AppMeterialButton(
                icon: Icons.arrow_back,
                iconColor: context.colors.neonBlue,
                padding: AppPadding.p4,
                iconSize: 25,
                onPressed: () {
                  _controllers[currentPage]?.pause();
                  widget.pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: ValueListenableBuilder(
                valueListenable: _isMuted,
                builder: (context, isMuted, _) {
                  return AppMeterialButton(
                    onPressed: () {
                      if (isMuted) {
                        _controllers[currentPage]?.setVolume(1);
                      } else {
                        _controllers[currentPage]?.setVolume(0);
                      }
                      _isMuted.value = !isMuted;
                    },
                    padding: AppPadding.p4,
                    icon: isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    iconSize: 25,
                  );
                },
              ),
            ),
          ],
        );
      },
      error: error,
      loading: loader,
    );
  }
}
