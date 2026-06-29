import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class AddFriendRequestUsecase
    extends FutureUsecase<void, AddFriendRequestParams> {
  final MyDataRepository repository;

  AddFriendRequestUsecase(this.repository);

  @override
  ResultFuture<void> call(AddFriendRequestParams params) {
    return repository.addFriendRequest(params.first, params.second);
  }
}

class AddFriendRequestParams {
  final FriendRequest first;
  final FriendRequest second;

  AddFriendRequestParams({required this.first, required this.second});
}
