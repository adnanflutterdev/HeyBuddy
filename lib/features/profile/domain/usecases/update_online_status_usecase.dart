import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class UpdateOnlineStatusUsecase
    extends FutureUsecase<void, UpdateOnlineStatusUsecaseParams> {
  final MyDataRepository repository;
  UpdateOnlineStatusUsecase(this.repository);

  @override
  ResultFuture<void> call(UpdateOnlineStatusUsecaseParams params) {
    return repository.updateOnlineStatus(params.uid, params.isOnline);
  }
}

class UpdateOnlineStatusUsecaseParams {
  final String uid;
  final bool isOnline;

  UpdateOnlineStatusUsecaseParams({
    required this.uid,
    required this.isOnline,
  });
}
