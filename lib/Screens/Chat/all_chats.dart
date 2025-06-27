import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/debug_print.dart';
import 'package:heybuddy/Provider/friend_provider.dart';
import 'package:heybuddy/Screens/Chat/chat_bubble.dart';
import 'package:my_progress_bar/loaders.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AllChats extends ConsumerStatefulWidget {
  const AllChats(
      {super.key,
      required this.chatId,
      required this.itemScrollController,
      required this.textFieldFocusNode});
  final String chatId;
  final ItemScrollController itemScrollController;
  final FocusNode textFieldFocusNode;

  @override
  ConsumerState<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends ConsumerState<AllChats> {
  late Future<int> lastIndex;
  String myUid = FirebaseAuth.instance.currentUser!.uid;
  bool wasFirstLoad = true;
  @override
  void initState() {
    super.initState();
    lastIndex = getUnseenIndex();
    updateActiveStatus();
  }

  Future<int> getUnseenIndex() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('userChats')
        .doc(widget.chatId)
        .get();
    if (snapshot.exists) {
      return snapshot.get('${myUid}LastIndex');
    }
    return 0;
  }

  void updateLastIndex(int length) async {
    await FirebaseFirestore.instance
        .collection('userChats')
        .doc(widget.chatId)
        .update({
      '${myUid}LastIndex': length - 1,
    });
  }

  void updateActiveStatus() async {
    await FirebaseFirestore.instance
        .collection('userChats')
        .doc(widget.chatId)
        .update({myUid: true});
  }

  void clearChatNotification(String fUid) async {
    final fire = FirebaseFirestore.instance.collection('userData').doc(myUid);
    DocumentSnapshot snapshot = await fire.get();
    Map chatNotification = snapshot.get('chatNotification');
    chatNotification.remove(fUid);
    await fire.update({'chatNotification': chatNotification});
  }

  @override
  Widget build(BuildContext context) {
    final friendRef = ref.watch(friendProvider);

    void updateSeen() async {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final chatRef = await firestore
          .collection('userChats')
          .doc(widget.chatId)
          .collection(friendRef.first)
          .where('seen', isEqualTo: false)
          .get();
      final batch = firestore.batch();
      for (var doc in chatRef.docs) {
        batch.update(doc.reference, {'seen': true});
      }
      await batch.commit();
    }

    return Expanded(
        child: FutureBuilder(
            future: getUnseenIndex(),
            builder: (context, fSnapshot) {
              if (fSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: JumpingCirclesLoader(
                  ballsColor: neonGreen,
                ));
              }
              int unseenIndex = fSnapshot.data! + 1;
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('userChats')
                      .doc(widget.chatId)
                      .collection(myUid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: JumpingCirclesLoader(
                        ballsColor: neonGreen,
                      ));
                    }
                    if (!snapshot.hasData && snapshot.hasError) {
                      return Text('Error Occured');
                    }
                    final allChats = snapshot.data!.docs;
                    List allDocs = List.generate(
                      allChats.length,
                      (index) => allChats[index].id,
                    );

                    updateSeen();
                    updateLastIndex(allChats.length);
                   
                    if (!wasFirstLoad &&
                        widget.itemScrollController.isAttached) {
                      
                      widget.itemScrollController.scrollTo(
                          index: allChats.length - 1,
                          duration: Duration(milliseconds: 300));
                    } else{
                      clearChatNotification(friendRef.first);
                    }
                    return ScrollablePositionedList.builder(
                      initialScrollIndex: unseenIndex,
                      itemScrollController: widget.itemScrollController,
                      itemCount: allChats.length,
                      itemBuilder: (context, index) {
                        wasFirstLoad =
                            false; // This makes sures that the chats properly scrolls whenever a new chat
                        // appears.

                        // In chat bubble, if index is '0' then the chat will be displayed directly without checking
                        // Otherwise passing current and a previous chat for checking
                        return ChatBubble(
                            index: index,
                            allDocs: allDocs,
                            chatId: widget.chatId,
                            textFieldFocusNode: widget.textFieldFocusNode,
                            itemScrollController: widget.itemScrollController,
                            unSeen: unseenIndex == index ? true : false,
                            chats: index == 0
                                ? [allChats[0]]
                                : [allChats[index - 1], allChats[index]]);
                      },
                    );
                  });
            }));
  }
}
