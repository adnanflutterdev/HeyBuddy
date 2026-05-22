import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class LogoutUsecase extends FutureUsecase<void,NoParams>{
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  @override
  ResultFuture<void> call(NoParams noParams) {
    return repository.logout();
  }
}
