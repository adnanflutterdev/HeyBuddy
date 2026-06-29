import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/repository/my_data_repository.dart';

class WithdrawRequestUsecase extends FutureUsecase<void, DualIdParam> {
  final MyDataRepository repository;

  WithdrawRequestUsecase(this.repository);

  @override
  ResultFuture<void> call(DualIdParam params) {
    return repository.withdrawRequest(params.first, params.second);
  }
}
