import 'package:flutter/material.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.fontSize,
  });
  final Widget? leading;
  final (String, String)? title;
  final List<Widget>? actions;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      titleSpacing: 0,
      actionsPadding: AppPadding.h8,
      title: (title != null)
          ? TitleText(text: title!, fontSize: fontSize, overflow: .ellipsis)
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
