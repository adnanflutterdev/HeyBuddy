import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/config/extensions/color_extension.dart';
import 'package:hey_buddy/core/const/app_padding.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/utils/error_state.dart';
import 'package:hey_buddy/core/utils/loader.dart';
import 'package:hey_buddy/core/widgets/app_text_field.dart';
import 'package:hey_buddy/features/chat/domain/entity/conversation.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/chat_provider.dart';
import 'package:hey_buddy/features/chat/presentation/widgets/friend_card.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/my_data_provider.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/users_provider.dart';

class ChatTab extends ConsumerStatefulWidget {
  const ChatTab({super.key});

  @override
  ConsumerState<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends ConsumerState<ChatTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void clear() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildSearch(),
          ValueListenableBuilder(
            valueListenable: _searchController,
            builder: (context, value, child) {
              if (value.text.trim().isEmpty) {
                return _buildConversations();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          _buildSearchedUsers(),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      color: context.colors.appbar,
      padding: AppPadding.symmetric(10, 12),
      child: ValueListenableBuilder(
        valueListenable: _searchController,
        builder: (context, searchQuery, _) {
          return AppTextField(
            prefixIcon: Icons.search,
            unfocusOnTapOutside: true,
            controller: _searchController,
            hintText: 'Search Friends by Username or Name',
            suffixIcon: searchQuery.text.trim().isNotEmpty ? Icons.close : null,
            onSuffixIconTapped: searchQuery.text.trim().isNotEmpty
                ? clear
                : null,
          );
        },
      ),
    );
  }

  Widget _buildConversations() {
    final myUid = ref.watch(uidProvider);
    final conversationRef = ref.watch(getConversationsProvider(myUid));
    final myFriendsRef = ref.watch(getFriendsProvider(myUid));

    if (myFriendsRef.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Expanded(
      child: conversationRef.when(
        data: (conversations) {
          final List<Conversation> myConversations = conversations
              .where((conversation) => conversation != null)
              .whereType<Conversation>()
              .toList();
          final myFriends = myFriendsRef.value ?? [];
          if (myConversations.isEmpty) {
            return const Center(child: Text('No Chats Yet'));
          } else {
            return ListView.builder(
              itemCount: myConversations.length,
              padding: AppPadding.symmetric(10, 12),
              itemBuilder: (context, index) {
                final conversation = myConversations[index];
                final fDataRef = ref.watch(userDataProvider(conversation.fUid));
                final friend = myFriends.firstWhere(
                  (friend) => friend.friendId == conversation.fUid,
                );
                return fDataRef.when(
                  data: (fData) {
                    return FriendCard(
                      fData: fData,
                      conversation: conversation,
                      friend: friend,
                    );
                  },
                  error: error,
                  loading: loader,
                );
              },
            );
          }
        },
        error: error,
        loading: loader,
      ),
    );
  }

  Widget _buildSearchedUsers() {
    return ValueListenableBuilder(
      valueListenable: _searchController,
      builder: (context, searchQuery, _) {
        if (searchQuery.text.trim().isEmpty) {
          return const SizedBox.shrink();
        }
        final myUid = ref.watch(uidProvider);
        final myFriendsRef = ref.watch(getFriendsProvider(myUid));
        final conversationRef = ref.watch(getConversationsProvider(myUid));
        if (conversationRef.isLoading) {
          return loader();
        }
        final myConversations = (conversationRef.value ?? [])
            .map((conversation) => conversation != null)
            .whereType<Conversation>()
            .toList();
        final fConversations = myConversations
            .map((conversation) => conversation.fUid)
            .toList();

        return myFriendsRef.when(
          data: (friends) {
            return Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                padding: AppPadding.symmetric(10, 15),
                itemBuilder: (context, index) {
                  final friendDataRef = ref.watch(
                    userDataProvider(friends[index].friendId),
                  );
                  return friendDataRef.when(
                    data: (fData) {
                      final query = searchQuery.text.trim().toLowerCase();
                      final name = fData.details.name.toLowerCase();
                      final username = fData.details.username.toLowerCase();
                      if (name.contains(query) || username.contains(query)) {
                        return FriendCard(
                          fData: fData,
                          friend: friends[index],
                          conversation: fConversations.contains(fData.uid)
                              ? myConversations.firstWhere(
                                  (conversation) =>
                                      conversation.fUid == fData.uid,
                                )
                              : null,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                    error: error,
                    loading: loader,
                  );
                },
              ),
            );
          },
          error: error,
          loading: loader,
        );
      },
    );
  }
}
