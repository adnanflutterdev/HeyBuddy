import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/presentation/riverpod/providers.dart';
import 'package:rxdart/rxdart.dart';

Stream<(List<Friend>, List<FriendRequest>, List<FriendRequest>)>
socialInteractions(Ref ref) {
  IdParam param = IdParam(ref.read(uidProvider));

  return Rx.combineLatest3(
    ref.read(getFriendsUsecaseProvider)(param),
    ref.read(getMyFriendRequestsUsecaseProvider)(param),
    ref.read(getOthersFriendRequestsUsecaseProvider)(param),
    (a, b, c) => (a, b, c),
  );
}

final socialInteractionsProvider =
    StreamProvider<(List<Friend>, List<FriendRequest>, List<FriendRequest>)>((
      ref,
    ) {
      return socialInteractions(ref);
    });
