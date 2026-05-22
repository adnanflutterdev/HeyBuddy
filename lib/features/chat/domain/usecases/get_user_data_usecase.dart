import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/chat/domain/repository/users_repository.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class GetUserDataUsecase extends FutureUsecase<UserData, GetUserDataParams> {
  final UsersRepository repository;

  GetUserDataUsecase(this.repository);

  @override
  ResultFuture<UserData> call(GetUserDataParams params) async {
    return await repository.getUserData(params.id);
  }
}

class GetUserDataParams {
  final String id;

  GetUserDataParams(this.id);
}
