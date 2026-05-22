import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/riverpod/firebase_provider.dart';
import 'package:hey_buddy/features/profile/domain/usecases/update_my_data_usecase.dart';
import 'package:hey_buddy/features/profile/domain/usecases/get_my_data_usecase.dart';
import 'package:hey_buddy/features/profile/data/repository/my_data_repository_impl.dart';
import 'package:hey_buddy/features/profile/data/data_sources/my_data_remote_source.dart';

final myDataSourceProvider = Provider((ref) {
  final firestore = ref.read(firebaseFirestoreProvider);
  return MyDataRemoteSource(firestore);
});

final myDataRepositoryProvider = Provider((ref) {
  final userRemoteDataSource = ref.read(myDataSourceProvider);
  return MyDataRepositoryImpl(userRemoteDataSource);
});

final getMyDataUsecaseProvider = Provider((ref) {
  final myDataRepository = ref.read(myDataRepositoryProvider);
  return GetMyDataUsecase(myDataRepository);
});

final updateMyDataUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(myDataRepositoryProvider);
  return UpdateMyDataUsecase(userRepository);
});
