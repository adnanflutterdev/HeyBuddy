import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Provider/chat_reply_provider.dart';
import 'package:heybuddy/Provider/chats_provider.dart';
import 'package:heybuddy/Provider/friend_provider.dart';
import 'package:heybuddy/Screens/Chat/freind_details.dart';
import 'package:my_progress_bar/loaders.dart';

class ChatHeader extends ConsumerWidget {
  const ChatHeader({super.key, required this.chatId});
  final String chatId;

  void updateActiveStatus() async {
    await FirebaseFirestore.instance
        .collection('userChats')
        .doc(chatId)
        .update({FirebaseAuth.instance.currentUser!.uid: false});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendRef = ref.watch(friendProvider);
    String myUid = FirebaseAuth.instance.currentUser!.uid;

    // chat selection providers and notifiers
    final chatProvider = ref.watch(chatSelectionProvider);
    final chatNotifier = ref.watch(chatSelectionProvider.notifier);

    // long press provider and notifier
    final longPressed = ref.watch(longPressedProvider);
    final longPressedNotifier = ref.watch(longPressedProvider.notifier);

    // copy text provider and notifier
    final copyProvider = ref.watch(chatCopyProvider);
    final copyNotifier = ref.watch(chatCopyProvider.notifier);

    // reply provider and notifier
    final replyProvider = ref.watch(chatReplyProvider);
    final replyNotifier = ref.watch(chatReplyProvider.notifier);

    void deleteChats() async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userChats')
          .doc(chatId)
          .collection(myUid)
          .get();
      final allDocuments = snapshot.docs;

      // Deleting chats
      List selectedDocuments = [];
      for (int x in chatProvider) {
        selectedDocuments.add(allDocuments[x]);
      }

      chatNotifier.clear();
      copyNotifier.clear();
      longPressedNotifier.stop();

      for (final x in selectedDocuments) {
        await FirebaseFirestore.instance
            .collection('userChats')
            .doc(chatId)
            .collection(myUid)
            .doc(x.id)
            .delete();
      }
    }

    void deleteChatsDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Deleting chats(${chatProvider.length})',
              style: roboto(fontSize: 22, color: Colors.red),
            ),
            content: Text('Deleting chats will remove these chats.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: roboto(fontSize: 15, color: neonBlue),
                  )),
              TextButton(
                  onPressed: () {
                    deleteChats();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Delete',
                    style: roboto(fontSize: 15, color: Colors.red),
                  ))
            ],
          );
        },
      );
    }

    Widget backButton = IconButton(
        tooltip: 'Back',
        onPressed: () {
          if (longPressed) {
            copyNotifier.clear();
            chatNotifier.clear();
            longPressedNotifier.stop();
            replyNotifier.clear();
          } else if (replyProvider.isNotEmpty) {
            replyNotifier.clear();
          } else {
            Navigator.of(context).pop();
          }
        },
        icon: const Icon(
          Icons.arrow_back,
          color: neonGreen,
        ));
    // Header Container
    return Container(
      // width and height
      width: double.infinity,
      height: 60,

      // Shadow
      decoration: BoxDecoration(color: appBarColor, boxShadow: [
        BoxShadow(offset: Offset(0, 2), blurRadius: 1, color: container)
      ]),

      // Streambuilder for loading friends data
      child: longPressed
          ? Row(
              children: [
                backButton,
                w10,
                Text(
                  '${chatProvider.length}',
                  style: roboto(
                      fontSize: 18, color: white, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: copyProvider.join('\n')));
                      chatNotifier.clear();
                      copyNotifier.clear();
                      longPressedNotifier.stop();
                    },
                    icon: Icon(
                      Icons.copy,
                      color: white,
                    )),
                IconButton(
                  onPressed: () {
                    deleteChatsDialog();
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                    color: white,
                  ),
                ),
                w10
              ],
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userData')
                  .doc(friendRef.first)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: RotatingCirclesLoader(
                      ballsColor: neonBlue,
                      loaderRadius: 20,
                    ),
                  );
                }
                if (!snapshot.hasData && snapshot.hasError) {
                  return Text('Error Occured');
                }
                final friendData = snapshot.data!.data()!;
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FriendDetails(
                          friendData: friendData,
                          chatUid: chatId,
                          fUid: friendRef.first,
                          myUid: myUid),
                    ));
                  },
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (replyProvider.isNotEmpty) {
                            replyNotifier.clear();
                          } else {
                            updateActiveStatus();
                            Navigator.of(context).pop();
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: neonGreen,
                          size: 30,
                        ),
                      ),
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: neonGreen)),
                        child: Center(
                          child: friendData['image'] != ''
                              ? CachedNetworkImage(
                                  imageUrl: friendData['image'],
                                  placeholder: (context, url) => CircleAvatar(
                                    radius: 25,
                                  ),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 25,
                                    backgroundImage: imageProvider,
                                  ),
                                )
                              : Image.asset('assets/icons/heyBuddy.png'),
                        ),
                      ),
                      w10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            friendData['name'],
                            style: TextStyle(
                                fontSize: 18,
                                color: neonBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            friendData['isActive'],
                            style: TextStyle(
                                fontSize: 12,
                                color: friendData['isActive'] == 'Online'
                                    ? neonGreen
                                    : Colors.red,
                                fontWeight: FontWeight.w300),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
