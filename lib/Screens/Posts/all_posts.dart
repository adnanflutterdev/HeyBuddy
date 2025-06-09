import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/widgets/loader.dart';
import 'package:heybuddy/Screens/Posts/posts.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({super.key});

  @override
  State<AllPosts> createState() => _AllPostsState();
}

class _AllPostsState extends State<AllPosts> {
  late Future<QuerySnapshot> posts;
  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  Future<QuerySnapshot> fetchPosts() async {
    return await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postNo')
        .get();
  }

  Future<void> reloadPosts() {
    setState(() {
      posts = fetchPosts();
    });
    return posts;
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader;
        }
        if (snapshot.data == null) {
          return const Text('No data found');
        }
        List postData = snapshot.data!.docs.reversed.toList();
        return RefreshIndicator(
            onRefresh: () => reloadPosts(), child: Posts(postData: postData));
      },
    );
  }
}
