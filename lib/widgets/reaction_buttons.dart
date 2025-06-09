import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Buttons/post_comment.dart';
import 'package:heybuddy/Buttons/post_dis_like.dart';
import 'package:heybuddy/Buttons/post_like.dart';
import 'package:heybuddy/Buttons/post_share.dart';

class ReactionButtons extends StatelessWidget {
  ReactionButtons(
      {super.key,
      required this.collection,
      required this.docId,
      required this.like,
      required this.disLike});
  final String collection;
  final String docId;
  final List like;
  final List disLike;

  final myUid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LikeButton(
            collection: collection,
            postId: docId,
            postLike: like,
            postDislike: disLike),
        LikeText(collection: collection, docId: docId),
        const Spacer(),
        DislikeButton(
            collection: collection,
            postId: docId,
            postLike: like,
            postDislike: disLike),
        DisLikeText(collection: collection, docId: docId),
        const Spacer(),
        CommentText(collection: collection, docId: docId),
        const Spacer(),
        const ShareButton(),
        ShareText(collection: collection, docId: docId),
        w10
      ],
    );
  }
}
