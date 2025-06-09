import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  bool isVisible = true;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      setState(() {
        isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Opacity(
            opacity: 1.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                color: textField,
                child: Center(child: Text('New Message(s)')),
              ),
            ),
          )
        : Container();
  }
}
