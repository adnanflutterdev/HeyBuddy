import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/repository/user_repository.dart';

class UpdateUserDataUsecase {
  final UserRepository repository;

  UpdateUserDataUsecase(this.repository);

  Future<Result> call(DetailsEntity details, ProfileEnity profile) {
    return repository.updateUserData(details, profile);
  }
}
