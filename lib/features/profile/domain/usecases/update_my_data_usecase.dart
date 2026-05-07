import 'package:hey_buddy/core/model/result.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class UpdateMyDataUsecase {
  final MyDataRepository repository;

  UpdateMyDataUsecase(this.repository);

  Future<Result> call(DetailsEntity details, ProfileEnity profile) {
    return repository.updateMyData(details, profile);
  }
}
