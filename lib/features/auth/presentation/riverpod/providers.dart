import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/auth/domain/usecases/login_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/logout_usecase.dart';
import 'package:hey_buddy/features/auth/domain/usecases/signup_usecase.dart';
import 'package:hey_buddy/features/auth/data/repository/auth_repository_impl.dart';
import 'package:hey_buddy/features/auth/data/data_sources/auth_remote_data_source.dart';

final authRemoteDataSourceProvider = Provider(
  (ref) => AuthRemoteDataSource(
    ref.read(firebaseAuthProvider),
    ref.read(firebaseFirestoreProvider),
  ),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider)),
);

final loginProvider = Provider(
  (ref) => LoginUsecase(ref.watch(authRepositoryProvider)),
);
final signupProvider = Provider(
  (ref) => SignupUsecase(ref.watch(authRepositoryProvider)),
);
final logoutProvider = Provider(
  (ref) => LogoutUsecase(ref.watch(authRepositoryProvider)),
);
