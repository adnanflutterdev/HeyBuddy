import 'package:hey_buddy/core/typedefs/typedefs.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/auth/domain/repository/auth_repository.dart';

class GoogleAuthUsecase extends FutureUsecase<void,NoParams> {
  final AuthRepository repository;

  GoogleAuthUsecase(this.repository);

  @override
  ResultFuture<void> call(NoParams params) {
    return repository.googleSignin();
  }
}