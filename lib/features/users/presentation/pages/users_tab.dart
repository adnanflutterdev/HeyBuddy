import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/config/extensions/size_extention.dart';
import 'package:hey_buddy/config/extensions/text_theme_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/const/app_spacing.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/core/widgets/profile_image.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/social_interactions_provider.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';

class UsersTab extends ConsumerStatefulWidget {
  const UsersTab({super.key});

  @override
  ConsumerState<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<UsersTab> {
  int tabIndex = 0;
  Timer? _queryTimer;
  bool _isTyping = false;
  final List<String> tabs = ['Friends', 'Requests'];
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier('');

  void resetTimer() {
    if (_queryTimer != null) {
      _isTyping = true;
      setState(() {});
      _queryTimer?.cancel();
      _queryTimer = Timer(const Duration(milliseconds: 500), () {
        _isTyping = false;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // StreamProviders
    final socialInteractionsRef = ref.watch(socialInteractionsProvider);

    return socialInteractionsRef.when(
      data: (socialInteractions) {
        final List<String> friendsId = socialInteractions.getFriendsId();
        final List<String> myFriendRequestsId = socialInteractions
            .getMyFriendRequestsId();
        final List<String> othersFriendRequestsId = socialInteractions
            .getOthersFriendRequestsId();

        final List<String> currentUsersId = tabIndex == 0
            ? friendsId
            : othersFriendRequestsId;
        return Column(
          children: [
            _buildSearch(),
            ValueListenableBuilder(
              valueListenable: _searchQuery,
              builder: (context, query, _) {
                if (query.isNotEmpty) {
                  if (_isTyping) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    final searchedUsersRef = ref.watch(
                      searchUsersProvider(query.trim()),
                    );

                    return searchedUsersRef.when(
                      data: (searchedUsers) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: searchedUsers.length,
                            itemBuilder: (context, index) {
                              return _buildUserCard(searchedUsers[index]);
                            },
                          ),
                        );
                      },
                      error: error,
                      loading: loader,
                    );
                  }
                }
                return Expanded(
                  child: Column(
                    children: [_buildTabs(), _buildUsers(currentUsersId)],
                  ),
                );
              },
            ),
          ],
        );
      },
      error: error,
      loading: loader,
    );
  }

  Widget _buildSearch() {
    return Container(
      color: context.colors.appbar,
      padding: AppPadding.p8,
      child: AppTextField(
        controller: _searchController,
        prefixIcon: Icons.search,
        suffixIcon: Icons.close,
        onSuffixIconTapped: () {
          _searchQuery.value = '';
          _searchController.clear();
        },

        onChanged: (value) {
          _searchQuery.value = value;
          resetTimer();
        },
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: List.generate(tabs.length, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              tabIndex = index;
            });
          },
          child: Container(
            height: 40,
            width: context.width / 2,
            color: tabIndex == index
                ? context.colors.container
                : context.colors.appbar,
            child: Center(child: Text(tabs[index])),
          ),
        );
      }),
    );
  }

  Widget _buildUsers(List<String> users) {
    if (users.isEmpty) {
      return Expanded(
        child: Center(
          child: Text('No Friend${tabIndex == 0 ? 's' : ' Requests'}'),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: users.length,
          padding: AppPadding.p12,
          itemBuilder: (context, index) {
            final userRef = ref.watch(userDataProvider(users[index]));
            return userRef.when(
              data: (user) {
                return _buildUserCard(user);
              },
              error: error,
              loading: loader,
            );
          },
        ),
      );
    }
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
