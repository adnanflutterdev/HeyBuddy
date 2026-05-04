import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';
import 'package:hey_buddy/features/post/presentation/widgets/post.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postIdsRef = ref.watch(postsProvider);
    return postIdsRef.when(
      data: (posts) {
        return ListView.separated(
          cacheExtent: 2000,
          padding: AppPadding.p8,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Post(post: posts[index]);
          },
          separatorBuilder: (context, index) {
            return AppSpacing.h16;
          },
        );
      },
      error: (_, _) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
