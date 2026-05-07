import 'package:hey_buddy/features/profile/data/repository/my_data_repository_impl.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class GetMyDataUsecase {
  final MyDataRepositoryImpl repository;

  GetMyDataUsecase(this.repository);

  Future<UserEntity> call() {
    return repository.getMyData();
  }
}
