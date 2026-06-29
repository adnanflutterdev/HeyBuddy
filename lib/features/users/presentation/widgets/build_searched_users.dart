import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/features/profile/domain/entity/social_interactions.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';
import 'package:hey_buddy/features/users/presentation/widgets/user_card.dart';

class BuildSearchedUsers extends ConsumerWidget {
  const BuildSearchedUsers({
    super.key,
    required this.query,
    required this.relations,
  });
  final String query;
  final Relations relations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedUsersRef = ref.watch(searchUsersProvider(query));

    return searchedUsersRef.when(
      data: (searchedUsers) {
        return Expanded(
          child: ListView.builder(
            itemCount: searchedUsers.length,
            itemBuilder: (context, index) {
              final user = searchedUsers[index];
              return UserCard(
                user: user,
                status: relations.getRelationStatus(user.uid),
              );
            },
          ),
        );
      },
      error: error,
      loading: loader,
    );
  }
}
