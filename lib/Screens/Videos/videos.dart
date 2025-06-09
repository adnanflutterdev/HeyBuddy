import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/MyVideoPlayer/my_video_player.dart';
import 'package:heybuddy/MyVideoPlayer/my_video_player_controller.dart';
import 'package:heybuddy/widgets/reaction_buttons.dart';

class Videos extends StatelessWidget {
  const Videos({super.key, required this.videos});
  final List videos;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: container,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userData')
                    .doc(videos[index]['userId'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          w10,
                          Container(
                            width: 45,
                            height: 45,
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: white,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  final userData = snapshot.data!.data();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        w10,
                        CachedNetworkImage(
                          imageUrl: userData!['image'],
                          placeholder: (context, url) => const CircleAvatar(
                            backgroundColor: white,
                          ),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 23,
                            backgroundImage: imageProvider,
                          ),
                        ),
                        w10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              userData['name'],
                              style: roboto(fontSize: 15, color: white),
                            ),
                            Text(
                              videos[index]['postAt'],
                              style: roboto(fontSize: 12, color: white),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                              videos[index]['date'],
                              style: roboto(fontSize: 12, color: white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )),

          const Spacer(),
          // Videos
          SizedBox(
            height: 400,
            child: MyVideoPlayer(
                myVideoPlayerController: MyVideoPlayerController.url(
                    source: Uri.parse(videos[index]['videoUrl']))),
          ),
          const Spacer(),
          // Content
          if (videos[index]['content'] != '')
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
              child: Text(
                videos[index]['content'],
                style: roboto(fontSize: 15, color: white),
              ),
            ),
          Container(
            color: container,
            child: ReactionButtons(
              collection: 'videos',
              docId: videos[index].id,
              like: videos[index]['like'],
              disLike: videos[index]['dislike'],
            ),
          )
        ],
      ),
    );
  }
}
