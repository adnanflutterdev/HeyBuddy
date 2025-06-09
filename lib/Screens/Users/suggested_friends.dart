import 'package:flutter/material.dart';
import 'package:heybuddy/Consts/colors.dart';
import 'package:heybuddy/Consts/text_style.dart';

class SuggestedFriends extends StatelessWidget {
  const SuggestedFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Comming Soon...',
        style: roboto(fontSize: 18, color: white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
