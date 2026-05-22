import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hey_buddy/features/chat/domain/usecases/get_user_data_usecase.dart';
import 'package:hey_buddy/features/chat/presentation/riverpod/providers.dart';
import 'package:hey_buddy/features/profile/domain/entity/user_entity.dart';

final usersDataProvider = FutureProvider.family<UserData, String>((
  ref,
  id,
) async {
  final getUserDataUsecase = ref.read(getUserDataUsecaseProvider);
  final result = await getUserDataUsecase(GetUserDataParams(id));
  return result.data ?? Future.error(result.message);
});
