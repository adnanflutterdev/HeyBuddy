import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/features/clip/presentation/riverpod/clip_provider.dart';
import 'package:hey_buddy/features/clip/presentation/widgets/build_clip.dart';

class ClipTab extends ConsumerStatefulWidget {
  const ClipTab({super.key});

  @override
  ConsumerState<ClipTab> createState() => _ClipTabState();
}

class _ClipTabState extends ConsumerState<ClipTab> {
  @override
  Widget build(BuildContext context) {
    final clipsRef = ref.watch(clipsProvider);
    return clipsRef.when(
      data: (clips) {
        return PageView.builder(
          scrollDirection: .vertical,
          itemCount: clips.length,
          itemBuilder: (context, index) {
            return BuildClip(clip: clips[index]);
          },
        );
      },
      error: error,
      loading: loader,
    );
  }
}
