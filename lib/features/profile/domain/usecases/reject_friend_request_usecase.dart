import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class RejectFriendRequestUsecase extends FutureUsecase<void, DualIdParam> {
  final MyDataRepository repository;

  RejectFriendRequestUsecase(this.repository);

  @override
  ResultFuture<void> call(DualIdParam params) {
    return repository.rejectFriendRequest(params.first, params.second);
  }
}
