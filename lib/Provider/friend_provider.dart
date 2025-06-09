import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendNotifier extends StateNotifier<Set> {
  FriendNotifier() : super({});

  void updateFriend(String fUid,Map friendData) {
    state = {fUid , friendData};
  }
}

final friendProvider = StateNotifierProvider<FriendNotifier,Set>((ref) => FriendNotifier());
