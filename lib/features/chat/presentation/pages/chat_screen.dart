import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/widgets/app_material_button.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/custom_app_bar.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.fData, required this.friend});
  final UserData fData;
  final Friend friend;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 70,
        leadingWidth: 40,
        titleWidget: _buildAppBarContent(),
        actions: [
          AppMaterialButton(
            iconSize: 25,
            isTransparent: true,
            icon: Icons.more_vert,
            padding: AppPadding.p4,
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container()),
            _buildTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Row(
      spacing: 10,
      children: [
        ProfileImage(imageUrl: widget.fData.profile.profileImage),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            children: [
              Text(
                widget.fData.details.name,
                style: context.style.h3.copyWith(
                  color: context.colors.neonBlue,
                ),
              ),
              Text(
                '● Online',
                style: context.style.bs2.copyWith(
                  color: context.colors.neonGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: AppPadding.h8,
      child: Row(
        spacing: 4,
        children: [
          AppMaterialButton(
            icon: Icons.add,
            isTransparent: true,
            iconSize: 25,
            padding: AppPadding.p4,
            onPressed: () {},
          ),
          Expanded(
            child: AppTextField(
              minLines: 1,
              maxLines: 4,
              controller: messageController,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: messageController,
            builder: (context, message, _) {
              if (message.text.trim().isNotEmpty) {
                return AppMaterialButton(
                  icon: Icons.send,
                  isTransparent: true,
                  iconSize: 25,
                  padding: AppPadding.p8,
                  onPressed: () {},
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
