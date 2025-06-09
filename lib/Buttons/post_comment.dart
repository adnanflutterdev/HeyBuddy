import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Comment/comment_screen.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/text_style.dart';

class CommentText extends StatelessWidget {
  const CommentText({super.key, required this.collection, required this.docId});
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
        final List comment = loadedData!['comment'];
        final String content = loadedData['content'];
        return Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      collection: collection,
                      postId: docId,
                      content: content,
                      width: MediaQuery.of(context).size.width - 60,
                    ),
                  ));
                },
                icon: const ImageIcon(
                  AssetImage('assets/icons/comment.png'),
                  size: 20,
                  color: white,
                )),
            Text(
              '${comment.length}',
              style: roboto(fontSize: 12, color: white),
            ),
          ],
        );
      },
    );
  }
}
