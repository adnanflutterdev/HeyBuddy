import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/text_style.dart';

class LikeText extends StatelessWidget {
  const LikeText({super.key, required this.collection, required this.docId});
  final String collection;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              width: 5, height: 5, child: CircularProgressIndicator());
        }
        final loadedData = snapshot.data!.data();
        final List likes = loadedData!['like'];
        return Text(
          '${likes.length}',
          style: roboto(fontSize: 12, color: white),
        );
      },
    );
  }
}

class LikeButton extends StatelessWidget {
  LikeButton({
    super.key,
    required this.collection,
    required this.postId,
    required this.postLike,
    required this.postDislike,
  });
  final String collection;
  final String postId;
  final List postLike;
  final List postDislike;

  final myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    void like(String myUid, String postId, List likedPosts, List disLikedPosts,
        List postlike, List postDislike) async {
      if (likedPosts.contains(postId)) {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(myUid)
            .update({
          'likedPosts': FieldValue.arrayRemove([postId]),
          'disLikedPosts': FieldValue.arrayRemove([postId]),
        });
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(postId)
            .update({
          'like': FieldValue.arrayRemove([myUid]),
          'dislike': FieldValue.arrayRemove([myUid]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(myUid)
            .update({
          'likedPosts': FieldValue.arrayUnion([postId]),
          'disLikedPosts': FieldValue.arrayRemove([postId]),
        });
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(postId)
            .update({
          'like': FieldValue.arrayUnion([myUid]),
          'dislike': FieldValue.arrayRemove([myUid]),
        });
      }
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('userData')
          .doc(myUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ImageIcon(
                  AssetImage('assets/icons/like.png'),
                  size: 20,
                  color: white,
                ),
              ]);
        }
        final userData = snapshot.data!.data();
        final List likedPosts = userData!['likedPosts'];
        final List disLikedPosts = userData['disLikedPosts'];
        return IconButton(
            onPressed: () {
              like(myUid, postId, likedPosts, disLikedPosts, postLike,
                  postDislike);
            },
            icon: ImageIcon(
              const AssetImage('assets/icons/like.png'),
              size: 20,
              color: likedPosts.contains(postId) ? neonBlue : white,
            ));
      },
    );
  }
}
