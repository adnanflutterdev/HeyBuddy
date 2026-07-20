import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/features/profile/domain/entity/social_interactions.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/social_interactions_provider.dart';
import 'package:hey_buddy/features/users/presentation/widgets/build_searched_users.dart';
import 'package:hey_buddy/features/users/presentation/widgets/build_user_with_relation.dart';

class UsersTab extends ConsumerStatefulWidget {
  const UsersTab({super.key});

  @override
  ConsumerState<UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends ConsumerState<UsersTab> {
  Timer? _queryTimer;
  bool _isTyping = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _queryTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //

    final socialInteractionsRef = ref.watch(socialInteractionsProvider);

    return socialInteractionsRef.when(
      data: (socialInteractions) {
        Relations relations = socialInteractions.getRelations();
        return Column(
          spacing: 20,
          children: [_buildSearch(), _buildBody(relations)],
        );
      },
      error: error,
      loading: loader,
    );
  }

  Widget _buildSearch() {
    void clear() {
      _searchController.clear();
    }

    void autoSearch(String value) async {
      _isTyping = true;
      setState(() {});
      _queryTimer?.cancel();
      _queryTimer = Timer(const Duration(milliseconds: 500), () {
        _isTyping = false;
        setState(() {});
      });
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.appbar,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(1, 1),
            blurRadius: 8,
            color: context.colors.shadow,
          ),
        ],
      ),
      padding: AppPadding.p8,
      child: ValueListenableBuilder(
        valueListenable: _searchController,
        builder: (context, searchQuery, _) {
          bool isNotEmpty = searchQuery.text.trim().isNotEmpty;
          return AppTextField(
            hintText: 'Search by username',
            controller: _searchController,
            prefixIcon: Icons.search,
            iconColor: context.colors.primaryText,
            suffixIcon: isNotEmpty ? Icons.close : null,
            onSuffixIconTapped: isNotEmpty ? clear : null,
            onChanged: autoSearch,
            unfocusOnTapOutside: true,
          );
        },
      ),
    );
  }

  Widget _buildBody(Relations relations) {
    return ValueListenableBuilder(
      valueListenable: _searchController,
      builder: (context, query, _) {
        //
        if (query.text.trim().isNotEmpty) {
          //
          if (query.text.trim().length < 3) {
            return const Expanded(
              child: Center(child: Text('Type minimum 3 characters')),
            );
          }
          if (_isTyping && _queryTimer != null) {
            return const Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return BuildSearchedUsers(
            query: query.text.trim(),
            relations: relations,
          );
        }
        return BuildUserWithRelation(relations: relations);
      },
    );
  }
}
