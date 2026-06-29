import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/app_chip.dart';
import 'package:hey_buddy/features/profile/domain/entity/social_interactions.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';
import 'package:hey_buddy/features/users/presentation/widgets/user_card.dart';

class BuildUserWithRelation extends ConsumerStatefulWidget {
  const BuildUserWithRelation({super.key, required this.relations});
  final Relations relations;

  @override
  ConsumerState<BuildUserWithRelation> createState() =>
      _BuildUserWithRelationState();
}

class _BuildUserWithRelationState extends ConsumerState<BuildUserWithRelation> {
  int tabIndex = 0;
  final List<String> tabs = ['Friends', 'Requests', 'My Requests'];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [_buildTabs(), _buildUsers(widget.relations)]),
    );
  }

  Widget _buildTabs() {
    final colors = context.colors;
    return Padding(
      padding: AppPadding.h12,
      child: Row(
        spacing: 15,
        children: List.generate(tabs.length, (index) {
          bool isSelected = tabIndex == index;
          return AppChip(
            onPressed: () {
              setState(() {
                tabIndex = index;
              });
            },
            label: tabs[index],
            radius: 20,
            foregroundColor: isSelected ? colors.neonBlue : colors.primaryText,
            backgroundColor: colors.card,
          );
        }),
      ),
    );
  }

  Widget _buildUsers(Relations relations) {
    List<String> users = switch (tabIndex) {
      0 => relations.friends,
      1 => relations.myRequests,
      2 => relations.othersRequests,
      _ => [],
    };
    String emptyMessage = switch (tabIndex) {
      0 => "Friends",
      1 => "Friends Requests",
      2 => "Requests Sent",
      _ => "",
    };

    if (users.isEmpty) {
      return Expanded(child: Center(child: Text('No $emptyMessage')));
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userRef = ref.watch(userDataProvider(users[index]));
            return userRef.when(
              data: (user) {
                return UserCard(
                  user: user,
                  status: relations.getRelationStatus(user.uid),
                );
              },
              error: error,
              loading: loader,
            );
          },
        ),
      );
    }
  }
}
