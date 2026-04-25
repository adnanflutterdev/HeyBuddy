import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postIdsRef = ref.watch(allPostIdsProvider);
    return postIdsRef.when(
      data: (postIds) {
        return ListView.builder(
          itemCount: postIds.length,
          itemBuilder: (context, index) {
            return _buildPost(ref, postIds[index]);
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
        return const SizedBox.shrink();
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
