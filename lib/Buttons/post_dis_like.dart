import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/text_style.dart';

class DisLikeText extends StatelessWidget {
  const DisLikeText({super.key, required this.collection, required this.docId});
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
        final List dislikes = loadedData!['dislike'];
        return Text(
          '${dislikes.length}',
          style: roboto(fontSize: 12, color: white),
        );
      },
    );
  }
}

class DislikeButton extends StatelessWidget {
  DislikeButton(
      {super.key,
      required this.collection,
      required this.postId,
      required this.postLike,
      required this.postDislike});
  final String collection;
  final String postId;
  final List postLike;
  final List postDislike;
  final myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    void dislike(String myUid, String postId, List likedPosts,
        List disLikedPosts, List like, List dislike) async {
      if (disLikedPosts.contains(postId)) {
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
          'dislike': FieldValue.arrayRemove([myUid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('userData')
            .doc(myUid)
            .update({
          'likedPosts': FieldValue.arrayRemove([postId]),
          'disLikedPosts': FieldValue.arrayUnion([postId]),
        });
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(postId)
            .update({
          'like': FieldValue.arrayRemove([myUid]),
          'dislike': FieldValue.arrayUnion([myUid]),
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
              dislike(myUid, postId, likedPosts, disLikedPosts, postLike,
                  postDislike);
            },
            icon: ImageIcon(
              const AssetImage('assets/icons/dislike.png'),
              size: 20,
              color: disLikedPosts.contains(postId) ? neonBlue : white,
            ));
      },
    );
  }
}
