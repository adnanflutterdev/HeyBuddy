import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/get_color.dart';

class MaterialTextButton extends StatelessWidget {
  const MaterialTextButton({
    super.key,
    this.style,
    this.onPressed,
    this.onTapDown,
    required this.text,
    this.isTransparent = false,
  });
  final Function()? onPressed;
  final Function(TapDownDetails details)? onTapDown;
  final String text;
  final TextStyle? style;
  final bool isTransparent;

  @override
  Widget build(BuildContext context) {
    final GetColor colors = context.colors;
    return Material(
      color: isTransparent ? Colors.transparent : colors.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onPressed,
        onTapDown: onTapDown,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        splashColor: isTransparent ? colors.bg : colors.disabledText,
        child: Padding(
          padding: AppPadding.symmetric(8, 4),
          child: Text(text, style: style ?? context.style.b1),
        ),
      ),
    );
  }
}
