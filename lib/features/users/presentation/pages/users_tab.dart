import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';

class UsersTab extends ConsumerStatefulWidget {
  const UsersTab({super.key});

  @override
  ConsumerState<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<UsersTab> {
  List<String> tabs = ['All Users', 'Friends', 'Requests'];
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    final tabWidth = context.width / 3;

    // StreamProviders
    final allUsersRef = ref.watch(allUsersProvider);

    return Column(
      children: [
        // Tabs
        Row(
          children: List.generate(tabs.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  tabIndex = index;
                });
              },
              child: Container(
                width: tabWidth,
                height: 40,
                color: tabIndex == index
                    ? context.colors.container
                    : context.colors.appbar,
                child: Center(child: Text(tabs[index])),
              ),
            );
          }),
        ),
        // Users
        Expanded(
          child: allUsersRef.when(
            data: (allUsers) {
              List<UserData> users = allUsers;

              if (users.isEmpty) {
                return const Center(child: Text('No users found'));
              }
              return ListView.builder(
                itemCount: users.length,
                padding: AppPadding.p12,
                itemBuilder: (context, index) {
                  return _buildUserCard(users[index]);
                },
              );
            },
            error: error,
            loading: loader,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserData user) {
    return Column(
      children: [
        GestureDetector(
          child: Row(
            mainAxisAlignment: .center,
            children: [
              ProfileImage(imageUrl: user.profile.profileImage, size: 50),
              AppSpacing.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(user.details.name, style: context.style.b1),
                    if (user.profile.bio != null &&
                        user.profile.bio!.isNotEmpty)
                      Text(
                        user.profile.bio!,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: context.style.bs1,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppPadding.symmetric(4, 8),
          child: const Divider(thickness: 0.5),
        ),
      ],
    );
  }
}
