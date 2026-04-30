import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/feed/riverpod/feed_provider.dart';

class PostActions extends StatelessWidget {
  const PostActions({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.container,
      padding: AppPadding.p12,
      child: Row(
        spacing: 12,
        children: [
          Consumer(
            builder: (context, ref, _) {
              final likeStream = ref.watch(postLikeStream(id));
              final uid = ref.read(uidProvider);
              return likeStream.when(
                data: (likes) {
                  bool isLiked = likes.contains(uid);
                  return Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isLiked) {
                            ref
                                .read(firebaseFirestoreProvider)
                                .collection('post')
                                .doc(id)
                                .collection('likes')
                                .doc(uid)
                                .delete();
                          } else {
                            ref
                                .read(firebaseFirestoreProvider)
                                .collection('post')
                                .doc(id)
                                .collection('likes')
                                .doc(uid)
                                .set({});
                          }
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          color: isLiked ? context.colors.error : null,
                        ),
                      ),
                      Text('${likes.length}', style: context.style.b2),
                    ],
                  );
                },
                error: (error, stackTrace) {
                  print(error);
                  print(stackTrace);
                  return Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      const Icon(Icons.favorite),
                      Text('0', style: context.style.b2),
                    ],
                  );
                },
                loading: () {
                  return Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      const Icon(Icons.favorite),
                      Text('loading...', style: context.style.b2),
                    ],
                  );
                },
              );
            },
          ),
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              const Icon(Icons.comment),
              Text('0', style: context.style.b2),
            ],
          ),
          Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              const Icon(Icons.share),
              Text('0', style: context.style.b2),
            ],
          ),
        ],
      ),
    );
  }
}
