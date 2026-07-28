import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/domain/repository/users_repository.dart';

class GetUserDataStreamUsecase extends StreamUsecase<UserData?, IdParam> {
  final UsersRepository repository;

  GetUserDataStreamUsecase(this.repository);

  @override
  ResultStream<UserData?> call(IdParam params) {
    return repository.getUserDataStream(params.id);
  }
}
