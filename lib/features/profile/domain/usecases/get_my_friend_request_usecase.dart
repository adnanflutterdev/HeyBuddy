import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend_request.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class GetMyFriendRequestUsecase
    extends StreamUsecase<List<FriendRequest>, IdParam> {
  final MyDataRepository repository;

  GetMyFriendRequestUsecase(this.repository);

  @override
  ResultStream<List<FriendRequest>> call(IdParam params) {
    return repository.getMyFriendRequests(params.id);
  }
}
