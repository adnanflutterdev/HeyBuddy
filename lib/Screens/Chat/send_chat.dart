import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/encrypter.dart';
import 'package:heybuddy/Functions/send_notification.dart';
import 'package:heybuddy/Functions/time_and_date.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:heybuddy/Provider/chat_reply_provider.dart';
import 'package:heybuddy/Provider/friend_provider.dart';
import 'package:heybuddy/Screens/Chat/send_image.dart';
import 'package:heybuddy/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera_image_picker/camera_image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SendChat extends ConsumerStatefulWidget {
  const SendChat(
      {super.key,
      required this.textFieldFocusNode,
      required this.chatId,
      required this.itemScrollController});

  final FocusNode textFieldFocusNode;
  final String chatId;
  final ItemScrollController itemScrollController;

  @override
  ConsumerState<SendChat> createState() => _SendChatState();
}

class _SendChatState extends ConsumerState<SendChat> {
  late TextEditingController textEditingController;
  late AudioPlayer audioPlayer;
  String myUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    audioPlayer = AudioPlayer();
  }

  void sendChat({
    required String name,
    required String imageUrl,
    required String fToken,
    required String fUid,
    required int length,
  }) async {
    bool status = await InternetConnectionChecker.instance.hasConnection;
    if (textEditingController.text.isNotEmpty) {
      if (status) {
        final replyProvider = ref.watch(chatReplyProvider);
        final replyNotifier = ref.watch(chatReplyProvider.notifier);
        Map<String, dynamic> chat = {};
        List dt = dateTime();
        String text = textEditingController.text.trim();
        String message = encrypter(text);
        textEditingController.clear();
        audioPlayer.play(AssetSource('audio/message_sent.wav'));

        String docId = '${Timestamp.now().microsecondsSinceEpoch}';
        final fire = FirebaseFirestore.instance
            .collection('userChats')
            .doc(widget.chatId);

        DocumentSnapshot userChatsSnapshot = await fire.get();
        final isActive = userChatsSnapshot.get(fUid);

        DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
            .collection('userData')
            .doc(fUid)
            .get();
        Map chatNotification = userDataSnapshot.get('chatNotification');

        if (replyProvider.isNotEmpty) {
          chat = {
            'second': dt[0],
            'time': dt[1],
            'date': dt[2],
            'seen': false,
            'edited': false,
            'userId': myUid,
            'type':
                replyProvider['type'] == 'text' ? 'text reply' : 'image reply',
            'docId': replyProvider['docId'],
            'message': replyProvider['message'] == ''
                ? ''
                : encrypter(replyProvider['message']),
            'replied message': message,
            'isMine': replyProvider['isMine']
          };
          if (replyProvider['type'] == 'image') {
            chat.addAll({'image': replyProvider['imageUrl']});
          }
        } else {
          chat = {
            'second': dt[0],
            'time': dt[1],
            'date': dt[2],
            'edited': false,
            'message': message,
            'seen': false,
            'type': 'text',
            'userId': myUid,
          };
        }
        replyNotifier.clear();
        if (!isActive) {
          List docList = chatNotification[myUid] ?? [];
          List newDocList = [docId];
         if(docList.isNotEmpty){
           newDocList.addAll(docList);
         }
          chatNotification[myUid] = newDocList;
          await FirebaseFirestore.instance
              .collection('userData')
              .doc(fUid)
              .update({'chatNotification': chatNotification});
          sendNotification(
              myUid: myUid,
              fToken: fToken,
              name: name,
              imageUrl: imageUrl,
              body: text);
        }
        // Adding in users chat
        await fire.collection(myUid).doc(docId).set(chat);
        // Adding in friends chat
        await fire.collection(fUid).doc(docId).set(chat);

        widget.itemScrollController
            .scrollTo(index: length, duration: Duration(milliseconds: 300));
      } else {
        showSnackBar();
      }
    }
  }

  void menu(RelativeRect position) {
    widget.textFieldFocusNode.unfocus();
    showMenu(
        context: context,
        position: position,
        menuPadding: EdgeInsets.all(0),
        items: [
          PopupMenuItem(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  tooltip: 'Select Image From Camera',
                  onPressed: () async {
                    Navigator.of(context).pop();
                    List<XFile> images =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CameraImagePicker(
                        cameras: camera,
                      ),
                    ));
                    if (images.isNotEmpty) {
                      Timer(Duration(milliseconds: 300), () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SendImage(
                            myUid: myUid,
                            images: images,
                            chatId: widget.chatId,
                            itemScrollController: widget.itemScrollController,
                          ),
                        ));
                      });
                    }
                  },
                  icon: Icon(Icons.camera_alt)),
              IconButton(
                  tooltip: 'Select Image From Gallery',
                  onPressed: () async {
                    Navigator.of(context).pop();
                    final List<XFile> images =
                        await ImagePicker().pickMultiImage(limit: 10);
                    if (images.isNotEmpty) {
                      if (!mounted) {
                        return;
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SendImage(
                          myUid: myUid,
                          images: images,
                          chatId: widget.chatId,
                          itemScrollController: widget.itemScrollController,
                        ),
                      ));
                    }
                  },
                  icon: Icon(Icons.photo)),
              IconButton(
                  tooltip: 'Closes Menu',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  )),
            ],
          ))
        ]);
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'No Internet Connection. Please Connect To Active Internet Connection',
      style: TextStyle(color: Colors.red),
    )));
  }

  @override
  void dispose() {
    textEditingController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Friend provider
    final friendData = ref.watch(friendProvider);

    // chat reply provider
    final replyNotifier = ref.watch(chatReplyProvider.notifier);
    final replyProvider = ref.watch(chatReplyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (replyProvider.isNotEmpty)
          Badge(
            alignment: Alignment(0.85, -0.9),
            label: IconButton(
                onPressed: () {
                  replyNotifier.clear();
                },
                icon: Icon(
                  Icons.cancel,
                  color: white,
                )),
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                    color: container, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            replyProvider['isMine']
                                ? 'You'
                                : replyProvider['name'],
                            style: roboto(fontSize: 16, color: neonBlue),
                          ),
                          // if ()
                          SizedBox(
                            width: width -
                                (replyProvider['type'] == 'image' ? 90 : 20),
                            child: Text(
                              '${replyProvider['type'] == 'image' ? '📷' : ''} ${replyProvider['message']}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: roboto(fontSize: 13, color: white),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (replyProvider['type'] == 'image')
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: replyProvider['imageUrl'],
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        Container(
          color: appBarColor,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: white,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: TextField(
                        controller: textEditingController,
                        focusNode: widget.textFieldFocusNode,
                        autofocus: false,
                        cursorColor: white,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        style: roboto(fontSize: 16, color: white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: container,
                          hintText: 'Write here...',
                          hintStyle: roboto(fontSize: 14, color: white),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                    onTapDown: (details) {
                      menu(RelativeRect.fromLTRB(details.globalPosition.dx,
                          details.globalPosition.dy, 0, 0));
                    },
                    child: SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.attach_file,
                        color: white,
                      ),
                    )),
                w10,
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('userData')
                        .doc(myUid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final myData = snapshot.data!.data()!;
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('userChats')
                              .doc(widget.chatId)
                              .collection(myUid)
                              .snapshots(),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            final length = snap.data!.docs.length;
                            return GestureDetector(
                              onTap: () {
                                sendChat(
                                    name: myData['name'],
                                    imageUrl: myData['image'],
                                    fUid: friendData.first,
                                    fToken: friendData.last['token'],
                                    length: length);
                              },
                              child: Image.asset(
                                'assets/icons/send.png',
                                width: 25,
                              ),
                            );
                          });
                    }),
                w10
              ],
            ),
          ),
        ),
      ],
    );
  }
}
