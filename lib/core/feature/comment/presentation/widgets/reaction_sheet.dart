import 'package:flutter/material.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/model/reaction_data.dart';

class ReactionSheet extends StatelessWidget {
  const ReactionSheet({super.key, required this.reactionData});
  final ReactionData reactionData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: AppPadding.p12,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text('Reactions', style: context.style.h3),
          AppSpacing.h4,
          Expanded(
            child: ListView.builder(
              itemCount: reactionData.reactionsCount.length,
              itemBuilder: (context, index) {
                ReactionCount reactionCount =
                    reactionData.reactionsCount[index];
                return ListTile(
                  leading: Text(
                    reactionCount.reactionEmoji,
                    style: context.style.heading,
                  ),
                  title: Text(
                    reactionCount.reactionName,
                    style: context.style.b1,
                  ),
                  trailing: Text(
                    '${reactionCount.count}',
                    style: context.style.b1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
