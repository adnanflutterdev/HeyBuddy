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
    final postIdsRef = ref.watch(allPostIdsProvider);
    return postIdsRef.when(
      data: (postIds) {
        return ListView.separated(
          padding: AppPadding.p16,
          itemCount: postIds.length,
          itemBuilder: (context, index) {
            return _buildPost(ref, postIds[index]);
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

  Widget _buildPost(WidgetRef ref, String postId) {
    final postRef = ref.watch(postDataProvider(postId));
    return postRef.when(
      data: (post) {
        if (post == null) {
          return const SizedBox.shrink();
        } else {
          return Post(post: post);
        }
      },
      error: (error, stackTrace) {
        return const SizedBox.shrink();
      },
      loading: () {
        return const SizedBox.shrink();
      },
    );
  }
}
