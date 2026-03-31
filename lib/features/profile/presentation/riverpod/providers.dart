import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/utils/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/profile/domain/usecases/user_data_usecase.dart';
import 'package:hey_buddy/features/profile/data/repository/user_repository_impl.dart';
import 'package:hey_buddy/features/profile/data/data_sources/user_remote_data_source.dart';

final userRemoteDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  final auth = ref.read(firebaseAuthProvider);

  return UserRemoteDataSource(auth.currentUser?.uid ?? '', firestore);
});

final userRepositoryProvider = Provider((ref) {
  final userRemoteDataSource = ref.read(userRemoteDataSourceProvider);
  return UserRepositoryImpl(userRemoteDataSource);
});

final userDataUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UserDataUsecase(userRepository);
});
