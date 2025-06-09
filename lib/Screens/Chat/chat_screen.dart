import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Screens/Chat/all_chats.dart';
import 'package:heybuddy/Screens/Chat/chat_header.dart';
import 'package:heybuddy/Screens/Chat/send_chat.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
  });
  final String chatId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late FocusNode textFieldFocusNode;
  late ItemScrollController itemScrollController;

  AppLifecycleState? appLifecycleState;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    textFieldFocusNode = FocusNode();
    itemScrollController = ItemScrollController();
  }

  void scrollToNewMessage(index) {
    itemScrollController.scrollTo(
        index: index, duration: Duration(milliseconds: 300));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    handleAppLifeCycle(state);
  }

  void handleAppLifeCycle(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await FirebaseFirestore.instance
          .collection('userChats')
          .doc(widget.chatId)
          .update({
            FirebaseAuth.instance.currentUser!.uid : true
          });
    } else {
      await FirebaseFirestore.instance
          .collection('userChats')
          .doc(widget.chatId)
          .update({
            FirebaseAuth.instance.currentUser!.uid : false
          });
    }
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Column(
        children: [
          ChatHeader(
            chatId: widget.chatId,
          ),
          AllChats(
            chatId: widget.chatId,
            itemScrollController: itemScrollController,
            textFieldFocusNode: textFieldFocusNode,
          ),
          SendChat(
            textFieldFocusNode: textFieldFocusNode,
            itemScrollController: itemScrollController,
            chatId: widget.chatId,
          )
        ],
      )),
    );
  }
}
