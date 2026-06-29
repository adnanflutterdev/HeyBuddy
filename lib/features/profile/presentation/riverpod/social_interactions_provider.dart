import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/social_interactions.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';
import 'package:rxdart/rxdart.dart';

Stream<SocialInteractions> socialInteractions(Ref ref) {
  IdParam param = IdParam(ref.watch(uidProvider));

  return Rx.combineLatest3(
    ref.read(getFriendsUsecaseProvider)(param),
    ref.read(getMyFriendRequestsUsecaseProvider)(param),
    ref.read(getOthersFriendRequestsUsecaseProvider)(param),
    (a, b, c) => SocialInteractions(
      friends: a,
      myFriendRequests: b,
      othersFriendRequests: c,
    ),
  );
}

final socialInteractionsProvider = StreamProvider<SocialInteractions>((ref) {
  return socialInteractions(ref);
});
