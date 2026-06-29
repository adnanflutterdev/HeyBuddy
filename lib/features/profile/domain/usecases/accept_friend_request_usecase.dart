import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class AcceptFriendRequestUsecase
    extends FutureUsecase<void, AcceptFriendRequestParams> {
  final MyDataRepository repository;

  AcceptFriendRequestUsecase(this.repository);

  @override
  ResultFuture<void> call(AcceptFriendRequestParams params) {
    return repository.acceptFriendRequest(params.first, params.second);
  }
}

class AcceptFriendRequestParams {
  final Friend first;
  final Friend second;

  AcceptFriendRequestParams({required this.first, required this.second});
}
