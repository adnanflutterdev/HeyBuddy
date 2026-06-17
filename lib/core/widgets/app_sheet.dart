import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';

class AppSheet extends ConsumerStatefulWidget {
  const AppSheet({super.key, required this.childrens});
  final List<Widget> childrens;
  @override
  ConsumerState<AppSheet> createState() => _AppSheetState();
}

class _AppSheetState extends ConsumerState<AppSheet> {
  late double _height = (9 / 10) * context.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: context.width,
      decoration: BoxDecoration(
        color: context.colors.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [_buildDragger(), ...widget.childrens],
          ),
        ),
      ),
    );
  }

  Widget _buildDragger() {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        double newHeight = _height - (details.primaryDelta ?? 0);
        if (newHeight < 300) {
          AppNavigator.pop();
        }
        setState(() {
          _height = newHeight.clamp(300, (9 / 10) * context.height);
        });
      },
      child: Container(
        color: Colors.transparent,
        width: context.width,
        height: 50,
        child: Stack(
          children: [
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: () {
                  AppNavigator.pop();
                },
                icon: const Icon(Icons.arrow_back, size: 30),
              ),
            ),
            Center(
              child: Container(
                width: 50,
                height: 8,
                decoration: BoxDecoration(
                  color: context.colors.secondaryText,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
