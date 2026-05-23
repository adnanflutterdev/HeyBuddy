import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/widgets/material_text_button.dart';

class ReplyButton extends StatelessWidget {
  const ReplyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialTextButton(
          text: 'Reply',
          onPressed: () {},
          style: context.style.b3.copyWith(color: context.colors.neonBlue),
        ),
        Text('(0)', style: context.style.bs3),
      ],
    );
  }
}
