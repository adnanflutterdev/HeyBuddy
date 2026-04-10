import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/model/result.dart';

void showMessenger(
  BuildContext context, {
  required Result result,
  bool showNeutral = false,
}) {
  GetColor colors = context.colors;
  Color foregroundColor = colors.onNeutral;
  Color backgroundColor = colors.neutral;

  if (!showNeutral) {
    foregroundColor = result.success ? colors.onSuccess : colors.onError;
    backgroundColor = result.success ? colors.success : colors.error;
  }

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: .floating,
      margin: AppPadding.symmetric(25, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: foregroundColor.withValues(alpha: 0.7),
          width: 0.2,
        ),
      ),
      showCloseIcon: true,
      closeIconColor: foregroundColor,
      elevation: 3,
      backgroundColor: backgroundColor,
      content: Text(
        result.message,
        style: context.style.b2.copyWith(color: foregroundColor),
      ),
    ),
  );
}
