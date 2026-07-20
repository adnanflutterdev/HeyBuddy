import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/title_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.titleWidget,
    this.leading,
    this.title,
    this.actions,
    this.fontSize,
    this.backgroundColor,
    this.height = 56,
    this.leadingWidth,
  });
  final Widget? leading;
  final Widget? titleWidget;
  final (String, String)? title;
  final List<Widget>? actions;
  final double? fontSize;
  final Color? backgroundColor;
  final double height;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      leadingWidth: leadingWidth,
      titleSpacing: 0,
      actionsPadding: AppPadding.h8,
      title:
          titleWidget ??
          (title != null
              ? TitleText(text: title!, fontSize: fontSize, overflow: .ellipsis)
              : null),
      actions: actions,
      backgroundColor: backgroundColor,
      toolbarHeight: height,
      shadowColor: context.colors.shadow,
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
