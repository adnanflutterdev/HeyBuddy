import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 30});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: .circle,
          border: Border.all(color: context.colors.neonBlue, width: 2),
          image: const DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
      ),
    );
  }
}
