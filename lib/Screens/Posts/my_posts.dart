import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colored_text.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/widgets/loader.dart';
import 'package:heybuddy/Screens/Posts/posts.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  late Future<QuerySnapshot> myPosts;
  @override
  void initState() {
    super.initState();
    myPosts = fetchMyData();
  }

  Future<QuerySnapshot> fetchMyData() async {
    final loadedData =
        await FirebaseFirestore.instance.collection('posts').get();
    return loadedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // My post
          Container(
            width: double.infinity,
            height: 60,
            color: appBarColor,
            child: Row(
              children: [
                w10,
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const ImageIcon(
                      AssetImage('assets/icons/back_arrow.png'),
                      color: neonGreen,
                    )),
                coloredText(text1: 'My ', text2: 'Posts', fontSize: 22),
                const Spacer(),
                w10,
              ],
            ),
          ),
          FutureBuilder(
            future: myPosts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(child: loader);
              }
              final loadedData = snapshot.data!.docs;
              final myUid = FirebaseAuth.instance.currentUser!.uid;
              List posts =
                  loadedData.where((e) => e['userId'] == myUid).toList();
              if (posts.isEmpty) {
                return const Center(
                  child: Text('You haven\'t post anything yet'),
                );
              }
              return Expanded(child: Posts(postData: posts.reversed.toList()));
            },
          )
        ],
      )),
    );
  }
}
