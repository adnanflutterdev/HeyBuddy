import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/widgets/image_slider.dart';
import 'package:heybuddy/widgets/reaction_buttons.dart';

class Posts extends StatelessWidget {
  const Posts({super.key, required this.postData});
  final List postData;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      cacheExtent: 1500,
      itemCount: postData.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: container,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('userData')
                        .doc(postData[index]['userId'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
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
                        );
                      }
                      final userData = snapshot.data!.data();
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
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
                                  style: roboto(
                                      fontSize: 14,
                                      color: white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  postData[index]['postAt'],
                                  style: roboto(fontSize: 11, color: white),
                                )
                              ],
                            ),
                            const Spacer(),
                            Column(
                              children: [
                                Text(
                                  postData[index]['date'],
                                  style: roboto(fontSize: 11, color: white),
                                ),
                              ],
                            ),
                            w10,
                          ],
                        ),
                      );
                    },
                  )),
              const Divider(
                color: bgColor,
                thickness: 1,
              ),
              // Content
              if (postData[index]['content'] != '')
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Text(
                    postData[index]['content'],
                    style: roboto(fontSize: 15, color: white),
                    
                  ),
                ),
              // Image
              if (!postData[index]['postUrl'].isEmpty)
                ImageSlider(images: postData[index]['postUrl']),
              ReactionButtons(
                collection: 'posts',
                docId: postData[index].id,
                like: postData[index]['like'],
                disLike: postData[index]['dislike'],
              )
            ],
          ),
        ),
      ),
    );
  }
}
