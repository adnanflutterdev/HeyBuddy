import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';
import 'package:hey_buddy/features/users/domain/usecases/get_user_data_usecase.dart';
import 'package:hey_buddy/features/users/presentation/riverpod/providers.dart';

final userDataProvider = FutureProvider.family<UserData, String>((
  ref,
  id,
) async {
  final getUserDataUsecase = ref.read(getUserDataUsecaseProvider);
  final result = await getUserDataUsecase(GetUserDataParams(id));
  return result.data ?? Future.error(result.message);
});
