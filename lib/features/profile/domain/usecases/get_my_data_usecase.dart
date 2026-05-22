import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/data/repository/my_data_repository_impl.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

class GetMyDataUsecase extends FutureUsecase<UserData, GetMyDataParams> {
  final MyDataRepositoryImpl repository;

  GetMyDataUsecase(this.repository);

  @override
  ResultFuture<UserData> call(GetMyDataParams params) {
    return repository.getMyData(params.uid);
  }
}

class GetMyDataParams {
  final String uid;

  GetMyDataParams(this.uid);
}
