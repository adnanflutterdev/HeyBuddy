import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/friend.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class GetFriendsUsecase extends StreamUsecase<List<Friend>, IdParam> {
  final MyDataRepository repository;

  GetFriendsUsecase(this.repository);

  @override
  ResultStream<List<Friend>> call(IdParam params) {
    return repository.getFriends(params.id);
  }
}
