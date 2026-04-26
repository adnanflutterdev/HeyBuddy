import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/const/get_color.dart';
import 'package:hey_buddy/core/widgets/app_logo.dart';
import 'package:hey_buddy/features/feed/domain/entity/feed_item_entity.dart';
import 'package:hey_buddy/features/post/presentation/widgets/post_images_slider.dart';
import 'package:intl/intl.dart';

class Post extends StatelessWidget {
  const Post({super.key, required this.post});
  final FeedItemEntity post;

  @override
  Widget build(BuildContext context) {
    GetColor colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.container,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: AppPadding.p12,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _buildPostHeader(context),
          Padding(
            padding: AppPadding.v8,
            child: Divider(thickness: 0.5, color: colors.divider),
          ),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildPostHeader(BuildContext context) {
    final createdAt = post.timestamps.createdAt.toDate();
    final isToday =
        DateFormat.yMMMEd().format(DateTime.now()) ==
        DateFormat.yMMMEd().format(createdAt);
    return Row(
      children: [
        _buildUserImage(),
        AppSpacing.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(post.user.name, style: context.style.b1),
              Text(DateFormat('hh:mm a').format(createdAt)),
            ],
          ),
        ),
        AppSpacing.w12,
        Text(
          isToday ? 'Today' : DateFormat.yMMMd().format(createdAt),
          style: context.style.bs2,
        ),
      ],
    );
  }

  Widget _buildUserImage() {
    return CachedNetworkImage(
      imageUrl: post.user.profileImage!,
      placeholder: (context, url) {
        return CircleAvatar(radius: 20, backgroundColor: context.colors.card);
      },
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(radius: 20, backgroundImage: imageProvider);
      },
      errorWidget: (context, _, _) {
        return const AppLogo(size: 40);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    ContentEntity content = post.content;
    return Column(
      spacing: 10,
      crossAxisAlignment: .start,
      children: [
        if (content.text.isNotEmpty) Text(content.text),
        if (content.media != null) PostImagesSlider(media: content.media!),
      ],
    );
  }
}
