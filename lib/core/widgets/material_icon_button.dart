import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/get_color.dart';

class MaterialIconButton extends StatelessWidget {
  const MaterialIconButton({super.key, this.onPressed, required this.icon});
  final Function()? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final GetColor colors = context.colors;
    return Material(
      color: colors.bg,
      shape: CircleBorder(side: BorderSide(color: colors.border)),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        splashColor: colors.disabledText,
        child: Padding(padding: AppPadding.p8, child: Icon(icon, size: 18)),
      ),
    );
  }
}
