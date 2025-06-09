import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Consts/spacers.dart';
import 'package:heybuddy/Consts/text_style.dart';
import 'package:heybuddy/Functions/decrypter.dart';
import 'package:heybuddy/Provider/chat_highlighter.dart';
import 'package:heybuddy/Provider/chat_reply_provider.dart';
import 'package:heybuddy/Provider/chats_provider.dart';
import 'package:heybuddy/Provider/friend_provider.dart';
import 'package:heybuddy/Screens/Chat/image_bubble.dart';
import 'package:heybuddy/Screens/Chat/new_message.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stroke_text/stroke_text.dart';

class ChatBubble extends ConsumerWidget {
  const ChatBubble(
      {super.key,
      required this.index,
      required this.chats,
      required this.unSeen,
      required this.chatId,
      required this.allDocs,
      required this.textFieldFocusNode,
      required this.itemScrollController});
  final int index;
  final List chats;
  final bool unSeen;
  final List allDocs;
  final String chatId;
  final FocusNode textFieldFocusNode;
  final ItemScrollController itemScrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // friend provider
    final friendData = ref.read(friendProvider);

    // chat selection providers and notifiers
    final chatNotifier = ref.watch(chatSelectionProvider.notifier);
    final chatProvider = ref.watch(chatSelectionProvider);

    // long press providers and notifiers
    final longPressedNotifier = ref.watch(longPressedProvider.notifier);
    final longPressed = ref.watch(longPressedProvider);

    // copy Notifier
    final copyNotifier = ref.watch(chatCopyProvider.notifier);

    // chat reply provider and Notifier
    final replyProvider = ref.watch(chatReplyProvider);
    final replyNotifier = ref.watch(chatReplyProvider.notifier);

    // Chat highlighter provider and notifier
    final highLighterProvider = ref.watch(chatHighlighterProvider);
    final highLighterNotifier = ref.watch(chatHighlighterProvider.notifier);

    int length = chats.length;
    bool isFirst = length == 1 ? true : false;
    int currentIndex = length == 1 ? 0 : 1;
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    bool isMyUid = chats[length == 1 ? 0 : 1]['userId'] == myUid;
    String message = chats[currentIndex]['message'] == ''
        ? ''
        : decrypter(chats[currentIndex]['message']);
    bool wasLastChatMine = length == 1
        ? isMyUid
            ? true
            : false
        : chats[0]['userId'] == chats[1]['userId']
            ? true
            : false;

    void updateActiveStatus() async {
      await FirebaseFirestore.instance
          .collection('userChats')
          .doc(chatId)
          .update({FirebaseAuth.instance.currentUser!.uid: false});
    }

    void chatSelection() {
      if (longPressed) {
        if (chatProvider.contains(index)) {
          if (chatProvider.length == 1) {
            chatNotifier.clear();
            copyNotifier.clear();
            longPressedNotifier.stop();
          } else {
            chatNotifier.removeChat(index);
            copyNotifier.removeText(message);
          }
        } else {
          chatNotifier.addChat(index);
          copyNotifier.addText(message);
        }
      } else {
        longPressedNotifier.start();
        chatNotifier.addChat(index);
        copyNotifier.addText(message);
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        if (longPressed) {
          longPressedNotifier.stop();
          chatNotifier.clear();
          copyNotifier.clear();
          replyNotifier.clear();
        } else if (replyProvider.isNotEmpty) {
          replyNotifier.clear();
        } else {
          updateActiveStatus();
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Column(
        children: [
          h10,
          // Date
          // This if helps to show all similar date once
          if (isFirst || chats[0]['date'] != chats[1]['date'])
            Container(
              width: double.infinity,
              color: appBarColor,
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 2,
                      color: white,
                    ),
                  ),
                  Text(
                    chats[currentIndex]['date'],
                    style: TextStyle(color: white),
                  ),
                  Expanded(
                    child: Divider(
                      height: 2,
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
          h10,
          // Dates ends
          //

          // New message announcement
          //
          if (unSeen && !isMyUid) NewMessage(),
          // Chat here
          //
          // Left and right padding of the chat box which decides the max with of the chat box.
          GestureDetector(
            onLongPress: chatSelection,
            onTap: () {
              textFieldFocusNode.unfocus();
              if (longPressed) {
                if (chatProvider.contains(index)) {
                  if (chatProvider.length == 1) {
                    chatNotifier.clear();
                    copyNotifier.clear();
                    longPressedNotifier.stop();
                  } else {
                    chatNotifier.removeChat(index);
                    copyNotifier.removeText(message);
                  }
                } else {
                  chatNotifier.addChat(index);
                  copyNotifier.addText(message);
                }
              } else {
                if (chats[currentIndex]['type'] == 'text reply' ||
                    chats[currentIndex]['type'] == 'image reply') {
                  final indexOfmessage =
                      allDocs.indexOf(chats[currentIndex]['docId']);
                  if (!indexOfmessage.isNegative) {
                    itemScrollController.scrollTo(
                        index: indexOfmessage,
                        duration: Duration(milliseconds: 300));
                    highLighterNotifier.addChat(indexOfmessage);
                    Timer(Duration(seconds: 2), () {
                      highLighterNotifier.clear();
                    });
                  } else {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      content: StrokeText(
                        text: 'Message is deleted',
                        textStyle: roboto(
                            fontSize: 15,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3),
                      ),
                      backgroundColor: appBarColor,
                    ));
                  }
                }
              }
            },
            child: Container(
              width: double.infinity,
              color: chatProvider.contains(index)
                  ? appBarColor
                  : highLighterProvider == index
                      ? isMyUid
                          ? neonGreen.withAlpha(100)
                          : neonBlue.withAlpha(100)
                      : null,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 3,
                    bottom: 3,
                    left: isMyUid
                        ? 50
                        : wasLastChatMine
                            ? 15
                            : 5,
                    right: isMyUid
                        ? wasLastChatMine
                            ? 13
                            : 5
                        : 50),
                // This container occupies the overall available width and align the chat on left and right.
                child: Dismissible(
                  key: Key('value'),
                  direction: DismissDirection.startToEnd,
                  confirmDismiss: (direction) async {
                    chats[currentIndex]['type'] == 'text' ||
                            chats[currentIndex]['type'] == 'text reply' ||
                            chats[currentIndex]['type'] == 'image reply'
                        ? replyNotifier.addTextReply(
                            docId: chats[currentIndex].id,
                            name: friendData.last['name'],
                            message: chats[currentIndex]['type'] ==
                                        'text reply' ||
                                    chats[currentIndex]['type'] == 'image reply'
                                ? chats[currentIndex]['replied message'] == ''
                                    ? ''
                                    : decrypter(
                                        chats[currentIndex]['replied message'])
                                : message,
                            isMine: isMyUid)
                        : replyNotifier.addImageReply(
                            docId: chats[currentIndex].id,
                            name: friendData.last['name'],
                            isMine: isMyUid,
                            imageUrl: chats[currentIndex]['images'][0],
                            message: message);
                    return false;
                  },
                  background: Icon(
                    Icons.reply,
                    size: 30,
                    color: white,
                  ),
                  child: Container(
                      alignment: isMyUid
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      // It creates the message sent and recieved nip.
                      child: ClipPath(
                        // Checking condition, if last chat was from the same user the nip will not drawn
                        // otherwise it will be drawn.
                        clipper: wasLastChatMine
                            ? null
                            : UpperNipMessageClipperTwo(
                                isMyUid
                                    ? MessageType.send
                                    : MessageType.receive,
                                nipHeight: 6,
                                nipWidth: 8,
                                bubbleRadius: 6),
                        child: Container(
                            decoration: BoxDecoration(
                                color: isMyUid
                                    ? neonGreen.withValues(alpha: 0.7)
                                    : neonBlue.withValues(alpha: 0.8),
                                borderRadius: wasLastChatMine
                                    ? BorderRadius.circular(6)
                                    : null),

                            // This padding is for the content inside the chatbubble
                            child: Padding(
                              padding: EdgeInsets.only(

                                  // adjusting left and right according to 'myUid' and was 'wasLastChatMine' so the
                                  // content look symmetric. "Nip" crops some content, so adjusting it needed.
                                  left: isMyUid
                                      ? 5
                                      : wasLastChatMine
                                          ? 2
                                          : 10,
                                  right: isMyUid
                                      ? wasLastChatMine
                                          ? 2
                                          : 10
                                      : 5,
                                  top: 5,
                                  bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (chats[currentIndex]['type'] ==
                                          'text reply' ||
                                      chats[currentIndex]['type'] ==
                                          'image reply')
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              110),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: container.withAlpha(240),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              StrokeText(
                                                text: chats[currentIndex]
                                                        ['isMine']
                                                    ? 'You'
                                                    : friendData.last['name'],
                                                textStyle: roboto(
                                                    fontSize: 15,
                                                    color: chats[currentIndex]
                                                            ['isMine']
                                                        ? neonGreen
                                                        : neonBlue),
                                              ),
                                              if (chats[currentIndex]['type'] ==
                                                  'image reply')
                                                Center(
                                                  child: SizedBox(
                                                    width: 80,
                                                    height: 80,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          chats[currentIndex]
                                                              ['image'],
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              if (message != '')
                                                Text(
                                                  message,
                                                  maxLines: 3,
                                                  style: roboto(
                                                      fontSize: 13,
                                                      color: white),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  //
                                  // Message padding
                                  chats[currentIndex]['type'] == 'text' ||
                                          chats[currentIndex]['type'] ==
                                              'text reply'
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: isMyUid ? 0 : 10,
                                              right: isMyUid ? 10 : 0),
                                          //
                                          // Message Here
                                          child: StrokeText(
                                            strokeWidth: 0.5,
                                            text: chats[currentIndex]['type'] ==
                                                    'text'
                                                ? message
                                                : decrypter(chats[currentIndex]
                                                    ['replied message']),
                                            textStyle: TextStyle(
                                              fontSize: 15,
                                            ),
                                          )

                                          // Message ends
                                          //
                                          )
                                      : chats[currentIndex]['type'] ==
                                              'image reply'
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: isMyUid ? 0 : 20,
                                                  right: isMyUid ? 20 : 0),
                                              child: StrokeText(
                                                  text: decrypter(
                                                      chats[currentIndex]
                                                          ['replied message'])),
                                            )
                                          : Column(
                                              children: [
                                                GestureDetector(
                                                  child: ImageBubble(
                                                      chatIndex: index,
                                                      message: message,
                                                      textFieldFocusNode:
                                                          textFieldFocusNode,
                                                      images:
                                                          chats[currentIndex]
                                                              ['images']),
                                                ),
                                                h5,
                                                if (message != '')
                                                  SizedBox(
                                                    width: 255,
                                                    child: StrokeText(
                                                      strokeWidth: 0.5,
                                                      text: message,
                                                      textStyle: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  )
                                              ],
                                            ),
                                  //
                                  // Time and seen icon here
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        chats[currentIndex]['time'],
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      if (isMyUid) w5,
                                      if (isMyUid)
                                        Icon(
                                          Icons.remove_red_eye_rounded,
                                          size: 15,
                                          color: chats[currentIndex]['seen']
                                              ? Colors.blue
                                              : container,
                                        )
                                    ],
                                  ),
                                  // Time and seen icon ends
                                  //
                                ],
                              ),
                            )),
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
