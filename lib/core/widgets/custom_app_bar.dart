import 'package:flutter/material.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.leading, this.title, this.actions});
  final Widget? leading;
  final (String, String)? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      titleSpacing: 8,
      title: (title != null) ? TitleText(text: title!) : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
