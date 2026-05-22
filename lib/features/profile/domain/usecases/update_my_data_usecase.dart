import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class UpdateMyDataUsecase extends FutureUsecase<void, UpdateMyDataParams> {
  final MyDataRepository repository;

  UpdateMyDataUsecase(this.repository);

  @override
  ResultFuture<void> call(UpdateMyDataParams params) {
    return repository.updateMyData(params.uid, params.details, params.profile);
  }
}

class UpdateMyDataParams {
  final String uid;
  final Details details;
  final Profile profile;

  UpdateMyDataParams(this.uid, this.details, this.profile);
}
