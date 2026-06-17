import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/placeholder_image.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/image_viewer.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/core/widgets/stroke_text.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';
import 'package:my_progress_bar/my_progress_bar.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hey_buddy/features/clip/domain/entity/clip.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/clip_player.dart';

class BuildClip extends StatelessWidget {
  const BuildClip({
    super.key,
    required this.clip,
    required this.isMuted,
    required this.controller,
  });
  final Clip clip;
  final ValueNotifier<bool> isMuted;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    void openProfile(String? imageUrl) async {
      controller.pause();
      await AppNavigator.push(
        ImageViewer(images: [imageUrl ?? placeholderImage]),
      );
      controller.play();
    }

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
              child: ClipPlayer(
                controller: controller,
                isMuted: isMuted,
                clipId: clip.id,
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            // color: Colors.black12,
            padding: AppPadding.h12,
            child: Consumer(
              builder: (context, ref, _) {
                final userRef = ref.watch(userDataProvider(clip.userId));
                return Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppSpacing.h8,
                    Row(
                      children: [
                        userRef.when(
                          data: (user) {
                            return Expanded(
                              child: Row(
                                mainAxisSize: .min,
                                spacing: 10,
                                children: [
                                  ProfileImage(
                                    imageUrl: user.profile.profileImage,
                                    onTap: () =>
                                        openProfile(user.profile.profileImage),
                                  ),
                                  StrokeText(
                                    text: user.details.name,
                                    overflow: .ellipsis,
                                    strokeWidth: 1,
                                    style: context.style.b1.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          error: error,
                          loading: loader,
                        ),
                        Builder(
                          builder: (context) {
                            return AppMeterialButton(
                              borderRadius: 8,
                              onPressed: () {},
                              text: 'Add Friend',
                              bgColor: Colors.black12,
                              style: context.style.bs1.copyWith(
                                color: Colors.white,
                              ),
                              padding: AppPadding.symmetric(8, 4),
                              borderColor: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                    if (clip.content.text != null &&
                        clip.content.text!.isNotEmpty) ...[
                      AppSpacing.h4,
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          clip.content.text!,
                          overflow: .ellipsis,
                          maxLines: 1,
                          style: context.style.b2.copyWith(color: Colors.white),
                        ),
                      ),
                    ] else
                      const SizedBox.shrink(),
                    ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, value, _) {
                        return HorizontalProgressBar(
                          trackHeight: 3,
                          thumbDiameter: 10,
                          maxValue: value.duration.inSeconds.toDouble(),
                          bufferedPosition: value.buffered.isNotEmpty
                              ? value.buffered.last.end.inSeconds.toDouble()
                              : null,
                          currentPosition: value.position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            await controller.seekTo(
                              Duration(seconds: value.toInt()),
                            );
                            controller.play();
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
