import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/users/data/data_sources/users_remote_data_source.dart';
import 'package:hey_buddy/features/users/data/repository/users_repository_impl.dart';
import 'package:hey_buddy/features/users/domain/usecases/get_user_data_usecase.dart';

final usersRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UsersRemoteDataSource(firestore);
});

final usersRepositoryProvider = Provider((ref) {
  final usersRemoteDataSource = ref.watch(usersRemoteDataSourceProvider);
  return UsersRepositoryImpl(usersRemoteDataSource);
});

final getUserDataUsecaseProvider = Provider((ref) {
  final usersRepository = ref.watch(usersRepositoryProvider);
  return GetUserDataUsecase(usersRepository);
});
