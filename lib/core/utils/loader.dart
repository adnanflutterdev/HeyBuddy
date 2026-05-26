import 'package:flutter/material.dart';

Widget loader({double? size}) {
  return Center(
    child: SizedBox(
      width: size ?? 30,
      height: size ?? 30,
      child: const CircularProgressIndicator(),
    ),
  );
}
