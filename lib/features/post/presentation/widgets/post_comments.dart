import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/core/const/app_navigator.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';

class PostComments extends StatefulWidget {
  const PostComments({super.key, required this.id});
  final String id;

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  double _height = 400;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: context.width,
      decoration: BoxDecoration(
        color: context.colors.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: .min,
          children: [
            GestureDetector(
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
                height: 40,
                child: Align(
                  alignment: .center,
                  child: Container(
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                      color: context.colors.secondaryText,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: AppPadding.p16,
              child: AppTextField(
                suffixIcon: Icons.send,
                unfocousOnTapOutside: true,
                onSuffixIconTapped: () {
                  print('Comment Sent');
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return const Text('hello');
                },
                separatorBuilder: (context, index) {
                  return AppSpacing.h8;
                },
                itemCount: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
