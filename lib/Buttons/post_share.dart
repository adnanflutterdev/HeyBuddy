import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/text_style.dart';

class ShareText extends StatelessWidget {
  const ShareText({super.key, required this.collection, required this.docId});
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
        final List share = loadedData!['share'];
        return Text(
          '${share.length}',
          style: roboto(fontSize: 12, color: white),
        );
      },
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {},
        icon: const ImageIcon(
          AssetImage('assets/icons/share.png'),
          size: 20,
          color: white,
        ));
  }
}
