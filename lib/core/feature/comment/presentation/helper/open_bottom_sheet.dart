import 'package:flutter/material.dart';

void openBottomSheet({required BuildContext context, required Widget sheet}) {
  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isScrollControlled: true,
    builder: (context) {
      return sheet;
    },
  );
}
