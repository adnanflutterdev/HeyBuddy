import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/core/usecase/usecase.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/domain/usecases/get_all_users_usecase.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/providers.dart';

final userDataProvider = FutureProvider.family<UserData, String>((
  ref,
  id,
) async {
  final getUserDataUsecase = ref.read(getUserDataUsecaseProvider);
  final result = await getUserDataUsecase(IdParam(id));

  return result.data ?? Future.error(result.message);
});

final userDataStreamProvider = StreamProvider.family<UserData?, String>((
  ref,
  id,
) {
  final getUserDataStreamUsecase = ref.read(getUserDataStreamUsecaseProvider);
  return getUserDataStreamUsecase(IdParam(id));
});

final searchUsersProvider = FutureProvider.family<List<UserData>, String>((
  ref,
  query,
) async {
  final getAllUsersUsecase = ref.read(getAllUsersUsecaseProvider);
  final result = await getAllUsersUsecase(QueryParam(query));
  return result.data ?? Future.error(result.message);
});
