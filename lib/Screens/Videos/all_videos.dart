import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/widgets/loader.dart';
import 'package:heybuddy/Screens/Videos/videos.dart';

class AllVideos extends StatefulWidget {
  const AllVideos({super.key});

  @override
  State<AllVideos> createState() => _AllVideosState();
}

class _AllVideosState extends State<AllVideos> {
  late Future<QuerySnapshot> videos;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
       );
    videos = fetchVideos();
  }

  Future<QuerySnapshot> fetchVideos() async {
    final video = await FirebaseFirestore.instance
        .collection('videos')
        .orderBy('videoNo')
        .get();
    return video;
  }

  Future<void> refresh() {
    setState(() {
      videos = fetchVideos();
    });
    return videos;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: FutureBuilder(
        future: videos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loader;
          }
          List videos = snapshot.data!.docs;
          return RefreshIndicator(
            child: Videos(
              videos: videos.reversed.toList(),
            ),
            onRefresh: () => refresh(),
          );
        },
      ),
    );
  }
}
