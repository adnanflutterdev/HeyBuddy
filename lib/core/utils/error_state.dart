import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget error(Object e, StackTrace s) {
  if (kDebugMode) {
    print(e);
    print(s);
  }
  return const SizedBox.shrink();
}
