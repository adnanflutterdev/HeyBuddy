import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:stroke_text/stroke_text.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen(
      {super.key,
      required this.postId,
      required this.collection,
      required this.content,
      required this.width});
  final String postId;
  final String collection;
  final String content;
  final double width;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late TextEditingController commentController;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // scrollController.animateTo(scrollController.,
    //     duration: const Duration(seconds: 1), curve: Curves.ease);
    void sendComment() async {
      if (commentController.text.isNotEmpty) {
        // FocusScope.of(context).unfocus();
        String message = commentController.text;
        commentController.clear();
        final dt = dateTime();
        await FirebaseFirestore.instance
            .collection(widget.collection)
            .doc(widget.postId)
            .update({
          'comment': FieldValue.arrayUnion([
            {
              'second': dt[0],
              'time': dt[1],
              'date': dt[2],
              'message': message,
              'userId': FirebaseAuth.instance.currentUser!.uid
            }
          ])
        });
      }
    }

    return Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
            child: Column(children: [
          Container(
            height: 60,
            color: appBarColor,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Timer(const Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                      });
                    },
                    icon: const ImageIcon(
                      AssetImage('assets/icons/back_arrow.png'),
                      color: neonGreen,
                    )),
                SizedBox(
                  width: widget.width,
                  child: Text(
                    '📷 ${widget.content}',
                    style: roboto(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.collection)
                  .doc(widget.postId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator()),
                  );
                }
                final postData = snapshot.data!.data();
                List comment = postData!['comment'];
                return Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: comment.length,
                        itemBuilder: (context, index) {
                          Map data = comment[index];
                          return Column(
                            children: [
                              if (index == 0)
                                Container(
                                    width: double.infinity,
                                    color: container,
                                    child: Center(
                                      child: Text(
                                        comment[index]['date'],
                                        style:
                                            roboto(fontSize: 12, color: white),
                                      ),
                                    )),
                              if ((index != 0) &&
                                  (comment[index - 1]['date'] !=
                                      comment[index]['date']))
                                Container(
                                    width: double.infinity,
                                    color: container,
                                    child: Center(
                                      child: Text(
                                        comment[index]['date'],
                                        style:
                                            roboto(fontSize: 12, color: white),
                                      ),
                                    )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 10),
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('userData')
                                        .doc(data['userId'])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      }
                                      final userData = snapshot.data!.data();
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          w20,
                                          CachedNetworkImage(
                                            imageUrl: userData!['image'],
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              backgroundImage: imageProvider,
                                              radius: 20,
                                            ),
                                          ),
                                          w5,
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: ClipPath(
                                                clipper:
                                                    UpperNipMessageClipperTwo(
                                                        MessageType.receive,
                                                        nipWidth: 10,
                                                        bubbleRadius: 8),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  alignment: Alignment.topLeft,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: container,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      StrokeText(
                                                        text:
                                                            userData['name'],
                                                        textStyle: roboto(
                                                            fontSize: 14,
                                                            color: white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 1),
                                                      ),
                                                      Text(
                                                        comment[index]
                                                            ['message'],
                                                        style: roboto(
                                                            color: textField,
                                                            fontSize: 13),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            comment[index]
                                                                ['time'],
                                                            style: roboto(
                                                                fontSize: 10,
                                                                color: white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          w20
                                        ],
                                      );
                                    }),
                              )
                            ],
                          );
                        }));
              }),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: container, borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: roboto(fontSize: 14, color: white),
                      cursorColor: white,
                      controller: commentController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Write here...',
                        hintStyle: roboto(fontSize: 14, color: white),
                        focusColor: white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  w10,
                  InkWell(
                    onTap: sendComment,
                    child: Image.asset(
                      'assets/icons/send.png',
                      width: 25,
                    ),
                  ),
                  w10
                ],
              ),
            ),
          ),
        ])));
  }
}
